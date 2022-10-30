//
//  FirstModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation

class FirstModel: SceneActionReceiver {
    
    //input
    var didReceiveSceneAction: (SceneAction) -> () = { action in }
    
    //output
    var manViewModel: PersonListViewModel {
        return privateManViewModel
    }
    
    var womanViewModel: PersonListViewModel {
        return privateWomanViewModel
    }
    
    //properties
    private var repository: RepositoryProtocol
    
    private var privateManViewModel: PersonListViewModel = PersonListViewModel()
    private var privateWomanViewModel: PersonListViewModel = PersonListViewModel()
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        bind()
    }
    
    func populateData() {
        
    }
    
    private func bind() {

    }
}
