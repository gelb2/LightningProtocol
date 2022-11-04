//
//  PopupViewModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import Foundation

enum collectionType {
    case list
    case grid
}

class PopupViewModel {
    //input
    var didReceiveButtonTap: (collectionType) -> () = { type in }
    
    //output
    var propergateButtonTap: (collectionType) -> () = { type in }
    
    //properties
    
    init() {
        bind()
    }
    
    private func bind() {
        didReceiveButtonTap = { [weak self] type in
            guard let self = self else { return }
            self.propergateButtonTap(type)
        }
    }
    
}
