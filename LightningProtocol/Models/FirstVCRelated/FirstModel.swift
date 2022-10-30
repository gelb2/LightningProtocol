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
    
    //properties
    private var repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        bind()
    }
    
    func populateData() {
        
    }
    
    private func bind() {

    }
}
