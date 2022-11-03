//
//  UIImage+Extension.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation
import UIKit

extension UIImage {
    enum ImageName: String {
        case calendar = "calendar.circle.fill"
        case docImage = "doc.text.image"
        case errorImage = "exclamationmark.circle.fill"
        case trashImage = "trash"
        case pencil_ruler = "pencil.and.ruler"
        case checkMark = "checkmark.diamond"
    }
    
    convenience init?(systemName: ImageName) {
        self.init(systemName: systemName.rawValue)
    }
    
    convenience init?(imageName: String) {
        self.init(named: imageName)
    }
}
