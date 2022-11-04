//
//  ActivityIndicatorViewStyling.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import Foundation
import UIKit

protocol ActivityIndicatorViewStyling: Styleable { }

extension ActivityIndicatorViewStyling {
    var indicatorStyle: (UIActivityIndicatorView) -> () {
        {
            $0.tintColor = .red
            $0.hidesWhenStopped = true
            $0.style = .large
            $0.color = .red
        }
    }
}
