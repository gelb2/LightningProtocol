//
//  PersonListViewModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/31.
//

import Foundation
// TODO: activity indicator 추가
class PersonListViewModel {
    
    //input
    var didReceiveEntityToRefreshAll: (RandomPeopleEntity) -> () = { entity in }
    var didReceiveEntityToAppend: (RandomPeopleEntity) -> () = { entity in }
    var didReceiveIndexPathItem: (Int) -> () = { item in }
    var didReceiveRefreshEvent: () -> () = { }
    
    var didReceiveRefreshCollectionLayoutEvent: (collectionType) -> () = { type in }
    
    var didSelectItem: (Int) -> () = { indexPathItem in }
    
    var didReceiveTrashItemEvent: () -> () = { }
    
    //output
    @MainThreadActor var didReceiveSomeItemTrashed: ( ((Void)) -> () )?
    @MainThreadActor var didReceiveViewModel: ( ((Void)) -> () )?
    @MainThreadActor var turnOnIndicator: ( ((Void)) -> () )?
    @MainThreadActor var turnOffIndicator: ( ((Void)) -> () )?
    @MainThreadActor var turnOnRefreshControl: ( ((Void)) -> () )?
    @MainThreadActor var turnOffRefreshControl: ( ((Void)) -> () )?
    
    var populatePageIndex: (Int) -> () = { item in }
    var populateRefreshEvent: () -> () = { }
    
    var populateRefreshCollectionLayoutEvent: (collectionType) -> () = { type in }
    
    var propergateThereIsItemsToDelete: () -> () = { }
    
    var propergateProfileTapEvent: (String) -> () = { largeProfileImageURL in }
    
    var dataSource: [PersonCellModel] {
        return privateDataSource
    }
    
    //properties
    private var didReceiveProfileTapEvent: (String) -> () = { largeProfileImageURL in }
    
    private var privateDataSource: [PersonCellModel] = []
    
    private var pageIndex: Int = 1
    
    init() {
        bind()
    }
    
    private func bind() {
        didReceiveEntityToRefreshAll = { [weak self] entity in
            guard let self = self else { return }
            Task {
                self.pageIndex = 1
                self.privateDataSource.removeAll()
                self.privateDataSource = await self.populateEntity(entity: entity)
                self.didReceiveViewModel?(())
                self.turnOffRefreshControl?(())
            }
        }
        
        didReceiveEntityToAppend = { [weak self] entity in
            guard let self = self else { return }
            
            Task {
                let newData = await self.populateEntity(entity: entity)
                // TODO: 중복되는 데이터 제거 고도화 및 재확인
                newData.forEach { value in
                    if !self.privateDataSource.contains(value) {
                        self.privateDataSource.append(value)
                    }
                }
                
                self.didReceiveViewModel?(())
                self.turnOffIndicator?(())
            }
        }
        
        didReceiveIndexPathItem = { [weak self] indexPathItem in
            guard let self = self else { return }
            if self.privateDataSource.count - 1 == indexPathItem {
                let nextPageIndex = self.pageIndex + 1
                self.pageIndex = nextPageIndex
                self.populatePageIndex(nextPageIndex)
                self.turnOnIndicator?(())
            }
        }
        
        didReceiveRefreshEvent = { [weak self] in
            guard let self = self else { return }
            self.turnOnRefreshControl?(())
            self.populateRefreshEvent()
        }
        
        didSelectItem = { [weak self] indexPathItem in
            guard let self = self else { return }
            self.findAndMarkSelectedItem(indexPathItem)
            self.propergateThereIsItemsToDelete()
        }
        
        didReceiveRefreshCollectionLayoutEvent = { [weak self] type in
            guard let self = self else { return }
            self.populateRefreshCollectionLayoutEvent(type)
        }
        
        didReceiveTrashItemEvent = { [weak self] in
            guard let self = self else { return }
            self.findAndTrashSelectedItem()
        }
        
        didReceiveProfileTapEvent = { [weak self] profileImageURL in
            guard let self = self else { return }
            self.propergateProfileTapEvent(profileImageURL)
        }
    }
    
    private func populateEntity(entity: RandomPeopleEntity) async -> [PersonCellModel] {
        // TODO: 셀모델이 아웃풋 별도로 만들어서 리턴하게 수정...엔티티는 모델에 그냥 값만 넘겨주게...
        let newData = entity.results.map { result -> PersonCellModel in
            let cellModel = PersonCellModel()
            cellModel.title = result.name.title
            cellModel.firstName = result.name.first
            cellModel.lastName = result.name.last
            cellModel.country = result.location.country
            cellModel.state = result.location.state
            cellModel.city = result.location.city
            cellModel.email = result.email
            cellModel.uuid = result.login.uuid
            cellModel.thumbURL = result.picture.thumbnail
            cellModel.mediumURL = result.picture.medium
            cellModel.largeURL = result.picture.large
            cellModel.phone = result.phone
            
            cellModel.propergateProfileTapEvent = self.didReceiveProfileTapEvent
            return cellModel
        }
        return newData
    }
    
    private func findAndTrashSelectedItem() {
        privateDataSource.removeAll { $0.isSelected == true }
        didReceiveSomeItemTrashed?(())
    }
    
    private func findAndMarkSelectedItem(_ indexPathItem: Int) {
        let isSelected = privateDataSource[indexPathItem].isSelected
        privateDataSource[indexPathItem].didReceiveSelectedEvent(!isSelected)
    }

    private func findLargeImageURLString(_ indexPathItem: Int) -> String {
        let imageURL = privateDataSource[indexPathItem].largeImageURLString
        return imageURL
    }
    
}
