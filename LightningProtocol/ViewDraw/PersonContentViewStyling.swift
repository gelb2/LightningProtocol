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
    
    var collectionViewFlowLayoutStyle: (UICollectionViewFlowLayout) -> () {
        {
            let cellSpacing: CGFloat = cellSpacing
            let columns: CGFloat = columns
            $0.scrollDirection = .vertical
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumLineSpacing = cellSpacing
            $0.minimumInteritemSpacing = cellSpacing
            let width = (UIScreen.main.bounds.width - cellSpacing * 2) / columns
            $0.itemSize = CGSize(width: width , height: width)
        }
    }
    
    private var cellSpacing: CGFloat {
        return 10.0
    }
    
    private var columns: CGFloat {
        return 3.0
    }
}
