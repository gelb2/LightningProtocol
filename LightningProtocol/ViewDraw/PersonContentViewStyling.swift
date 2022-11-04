//
//  PersonContentViewStyling.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/01.
//

import Foundation
import UIKit

protocol PersonContentViewStyling: Styleable { }

extension PersonContentViewStyling {
    
    var collectionViewStyle: (UICollectionView) -> () {
        {
            $0.backgroundColor = .white
        }
    }
}
