//
//  PopupViewStyling.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/04.
//

import Foundation
import UIKit

protocol PopupViewStyling: Styleable { }

extension PopupViewStyling {
    var verticalStackViewStyle: (UIStackView) -> () {
        {
            $0.axis = .vertical
        }
    }
    
    var listButtonStyle: (UIButton) -> () {
        {
            $0.setTitle("리스트", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    var gridButtonStyle: (UIButton) -> () {
        {
            $0.setTitle("그리드", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
    }
}
