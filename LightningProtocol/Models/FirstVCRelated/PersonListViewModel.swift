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
    
    //output
    @MainThreadActor var didReceiveViewModel: ( ((Void)) -> () )?
    @MainThreadActor var turnOnIndicator: ( ((Void)) -> () )?
    @MainThreadActor var turnOffIndicator: ( ((Void)) -> () )?
    @MainThreadActor var turnOnRefreshControl: ( ((Void)) -> () )?
    @MainThreadActor var turnOffRefreshControl: ( ((Void)) -> () )?
    
    var populatePageIndex: (Int) -> () = { item in }
    var populateRefreshEvent: () -> () = { }
    
    var dataSource: [PersonCellModel] {
        return privateDataSource
    }
    
    //properties
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
                self.privateDataSource = self.privateDataSource + newData
                // TODO: 중복되는 데이터 제거
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
            }
        }
        
        didReceiveRefreshEvent = { [weak self] in
            guard let self = self else { return }
            self.turnOnRefreshControl?(())
            self.populateRefreshEvent()
        }
    }
    
    private func populateEntity(entity: RandomPeopleEntity) async -> [PersonCellModel] {
        
        let newData = entity.results.map { result -> PersonCellModel in
            let cellModel = PersonCellModel()
            cellModel.name = "[\(result.name.title)]" + " " + result.name.first + " " + result.name.last
            cellModel.location = result.location.country + " / " + result.location.state + " / " + result.location.city
            cellModel.email = result.email
            cellModel.uuid = result.login.uuid
            cellModel.thumbImageURLString = result.picture.thumbnail
            cellModel.mediumImageURLString = result.picture.medium
            cellModel.largeImageURLString = result.picture.large
            return cellModel
        }
        return newData
    }
    
}
