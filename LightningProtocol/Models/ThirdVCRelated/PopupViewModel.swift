//
//  PopupViewModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import Foundation

class PopupViewModel {
    //input
    var didReceiveButtonTap = { }
    
    //output
    var propergateButtonTap = { }
    
    //properties
    
    init() {
        bind()
    }
    
    private func bind() {
        didReceiveButtonTap = { [weak self] in
            guard let self = self else { return }
            self.propergateButtonTap()
        }
    }
    
}
