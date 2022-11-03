//
//  ProfileZoomModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation

class ProfileZoomModel {
    
    //input
    var largeImageURLString: String?
    
    //output
    var profileZoomContentViewModel: ProfileZoomContentViewModel {
        return privateProfileZoomContentViewModel
    }
    
    //properties
    private var privateProfileZoomContentViewModel: ProfileZoomContentViewModel = ProfileZoomContentViewModel()
    
    init() {
        bind()
    }
    
    func populateData() {
        privateProfileZoomContentViewModel.didReceiveImageURLString(largeImageURLString)
    }
    
    private func bind() {
     
    }
    
}
