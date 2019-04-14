//
//  UIView.swift
//  codeACity2
//
//  Created by Isaac Douglas on 14/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import Foundation

extension UIView {
    func roundedCorners(radius: CGFloat = 10) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func circularCorners() {
        layer.cornerRadius = layer.bounds.height / 2
        clipsToBounds = true
    }
    
    func shadow() {
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        layer.shouldRasterize = false
    }
}
