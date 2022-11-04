//
//  PersonSelectionViewStyling.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/01.
//

import Foundation
import UIKit

protocol PersonSelectionViewStyling: Styleable { }

extension PersonSelectionViewStyling {
    var manButtonStyle: (UIButton) -> () {
        {
            $0.setTitle("남자", for: .normal)
            $0.setTitleColor(.red, for: .selected)
            $0.setTitleColor(.lightGray, for: .normal)
        }
    }
    
    var womanButtonStyle: (UIButton) -> () {
        {
            $0.setTitle("여자", for: .normal)
            $0.setTitleColor(.red, for: .selected)
            $0.setTitleColor(.lightGray, for: .normal)
        }
    }
}
