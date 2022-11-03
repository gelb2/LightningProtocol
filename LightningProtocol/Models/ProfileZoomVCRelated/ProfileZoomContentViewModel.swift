//
//  ProfileZoomContentViewModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import Foundation

class ProfileZoomContentViewModel {
    
    //input
    var didReceiveImageURLString: (String?) -> () = { url in }
    
    //output
    @MainThreadActor var loadImage: ( (String) -> () )?
    
    //properties
    
    private var largeImageURLString: String? {
        didSet {
            if let url = largeImageURLString {
                loadImage?(url)
            }
        }
    }
    
    init() {
        self.largeImageURLString = nil
        bind()
    }
    
    private func bind() {
        didReceiveImageURLString = { [weak self] urlString in
            guard let self = self else { return }
            self.largeImageURLString = urlString
        }
    }
}
