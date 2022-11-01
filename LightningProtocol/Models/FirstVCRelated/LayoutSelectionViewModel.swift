//
//  LayoutSelectionViewModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import Foundation

class LayoutSelectionViewModel {
    
    //input
    var didReceiveTapEvent: () -> () = { }
    
    //output
    var populateTapEvent: () -> () = { }
    
    //properties
    
    init() {
        bind()
    }
    
    private func bind() {
        didReceiveTapEvent = { [weak self] in
            guard let self = self else { return }
            self.populateTapEvent()
        }
    }
}
