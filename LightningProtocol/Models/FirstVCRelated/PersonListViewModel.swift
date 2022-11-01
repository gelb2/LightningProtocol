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
    var didReceiveEntity: (RandomPeopleEntity) -> () = { entity in }
    var didReceiveIndexPathItem: (Int) -> () = { item in }
    
    //output
    @MainThreadActor var didReceiveViewModel: ( ((Void)) -> () )?
    @MainThreadActor var turnOnIndicator: ( ((Void)) -> () )?
    @MainThreadActor var turnOffIndicator: ( ((Void)) -> () )?
    
    var populatePageIndex: (Int) -> () = { item in }
    
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
        didReceiveEntity = { [weak self] entity in
            guard let self = self else { return }
            
            Task {
                await self.populateEntity(entity: entity)
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
    }
    
    private func populateEntity(entity: RandomPeopleEntity) async {
        
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
        
        privateDataSource = privateDataSource + newData
    }
    
}
