//
//  PersonGridCellStyling.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import Foundation
import UIKit

protocol PersonGridCellStyling: Styleable { }

extension PersonGridCellStyling {
    var cellNameLabelStyling: (UILabel) -> () {
        {
            $0.textColor = .graySecondary
            $0.font = .appleSDGothicNeo(weight: .bold, size: 16)
            $0.textAlignment = .left
            $0.text = "namenamename"
        }
    }
    
    var cellProfileImageViewStyling: (UIImageView) -> () {
        {
            $0.layer.cornerRadius = 12
            $0.layer.shadowColor = UIColor(red: 0.271, green: 0.357, blue: 0.388, alpha: 0.2).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 1)
            $0.layer.shadowRadius = 8
            $0.clipsToBounds = true
            $0.image = UIImage(systemName: .docImage)
        }
    }
    
    var cellVerticalStackViewStyling: (UIStackView) -> () {
        {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.spacing = 4.0
        }
    }
    
    var cellCheckImageViewStyling: (UIImageView) -> () {
        {
            $0.image = UIImage(systemName: .checkMark)
        }
    }
}
