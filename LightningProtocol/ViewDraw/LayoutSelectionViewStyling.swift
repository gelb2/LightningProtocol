//
//  LayoutSelectionViewStyling.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import Foundation
import UIKit

protocol LayoutSelectionViewStyling: Styleable { }

extension LayoutSelectionViewStyling {
    
    var flotingButtonStyle: (UIButton) -> () {
        {
            $0.setImage(UIImage(systemName: .pencil_ruler), for: .normal)
            $0.tintColor = .white
            $0.setBackgroundColor(.red, for: .normal)
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }
    }
}
