//
//  UIScrollView+Extension.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToView(view:UIView, animated: Bool) {

        if let origin = view.superview {
            let subViewStartingPoint = origin.convert(view.frame.origin, to: self)
            self.scrollRectToVisible(CGRect(x:subViewStartingPoint.x, y:subViewStartingPoint.y,width: self.frame.width, height: self.frame.height), animated: animated)
        }
    }
}
