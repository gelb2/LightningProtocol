//
//  PersonSelectionViewModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/01.
//

import Foundation

class PersonSelectionViewModel {
    
    //input
    var didSegmentChange: (GenderType) -> () = { type in }

    //output
    var populateSelectedTypeToSelectionView: (GenderType) -> () = { type in }
    var propergateSelectedTypeToRelatedModel: (GenderType) -> () = { type in }
    
    //properties
    private var privateSelectedType: GenderType {
        didSet {
            populateSelectedTypeToSelectionView(self.privateSelectedType)
            propergateSelectedTypeToRelatedModel(self.privateSelectedType)
        }
    }
    
    init() {
        privateSelectedType = .male
        bind()
    }
    
    private func bind() {
        didSegmentChange = { [weak self] type in
            guard let self = self else { return }
            self.privateSelectedType = type
        }
    }
    
}
