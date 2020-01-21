//
//  HelperFile.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 11/11/2019.
//  Copyright © 2019 Am GHAZNAVI. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.red.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = frame.height / 10
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addShadowPlusRed() {
        layer.cornerRadius = frame.height / 12.5
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowOpacity = 0.75
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addShadowPlusGreen() {
        layer.cornerRadius = frame.height / 12.5
        layer.shadowColor = UIColor.green.cgColor
        layer.shadowOpacity = 0.75
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addShadowPlusPlus() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addShadowButton() {
        layer.cornerRadius = frame.height / 2
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    func textBoxShadow() {
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
    }
    
    func roundButton() {
        layer.masksToBounds = true
        layer.cornerRadius = frame.height / 2
    }
    
    func addShadowTextLabel() {
        layer.cornerRadius = frame.height / 12.5
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
     
}


extension UIColor {
    
    // Setup custom colours we can use throughout the app using hex values
    static let focusOnRed = UIColor(hex: 0xBE271B)
    static let focusOnBackgroundColor = UIColor(hex: 0xF9F6F5)
    static let focusOnBlack = UIColor(hex: 0x000000)
    static let focusOnGrey = UIColor(red: 117, green: 117, blue: 117)
    static let focusOnGreen = UIColor(hex: 0x1D5B27)
    
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}
