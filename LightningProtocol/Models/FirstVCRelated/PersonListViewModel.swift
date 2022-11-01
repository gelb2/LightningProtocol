//
//  PersonListViewModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/31.
//

import Foundation

class PersonListViewModel {
    
    //input
    var didReceiveEntity: (RandomPeopleEntity) -> () = { entity in }
    
    //output
    @MainThreadActor var didReceiveViewModel: ( ((Void)) -> () )?
    @MainThreadActor var turnOnIndicator: ( ((Void)) -> () )?
    @MainThreadActor var turnOffIndicator: ( ((Void)) -> () )?
    
    var dataSource: [PersonCellModel] {
        return privateDataSource
    }
    
    //properties
    var privateDataSource: [PersonCellModel] = []
    
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
    }
    
    private func populateEntity(entity: RandomPeopleEntity) async {
        let data = entity.results.map { result -> PersonCellModel in
            let cellModel = PersonCellModel()
            cellModel.name = result.name.title + result.name.first + result.name.last
            cellModel.location = result.location.country + "/" + result.location.state + "/" + result.location.city
            cellModel.email = result.email
            cellModel.uuid = result.login.uuid
            cellModel.thumbImageURLString = result.picture.thumbnail
            cellModel.mediumImageURLString = result.picture.medium
            cellModel.largeImageURLString = result.picture.large
            return cellModel
        }
    }
    
}
