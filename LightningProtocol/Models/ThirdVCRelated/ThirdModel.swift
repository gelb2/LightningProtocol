//
//  ThirdModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation

class ThirdModel {
    //input
    
    //output
    @MainThreadActor var routeSubject: ((SceneCategory) -> ())?
    
    var contentViewModel: ContentViewModel {
        return privateContentViewModel
    }
    
    //properties
    private var privateContentViewModel: ContentViewModel = ContentViewModel()
    
    init() {
        bind()
    }
    
    private func bind() {
        privateContentViewModel.propergateTapGesture = { [weak self] in
            guard let self = self else { return }
            
            self.routeSubject?(.close)
        }
        
        privateContentViewModel.propergateButtonTap = {
            print("propergate button tap")
            let context = SceneContext(dependency: FirstSceneAction.refresh)
            
            self.routeSubject?(.closeWithAction(.main(.firstViewControllerWithAction(context: context))))
        }
    }
    
}
