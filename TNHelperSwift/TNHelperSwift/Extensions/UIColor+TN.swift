//
//  UIColor+TN.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static func tnmobileGreen() -> UIColor {
        return UIColor(hexString: "3FD714")
    }
    
    static func tnmobileWhite() -> UIColor {
        return UIColor(hexString: "FFFFFF")
    }
    
    static func tnmobileDarkGrey() -> UIColor {
        return UIColor(hexString: "444444")
    }
    
    static func tnmobileBlue() -> UIColor {
        return UIColor(hexString: "007EA4")
    }
    
    static func tnmobileOrange() -> UIColor {
        return UIColor(hexString: "FF6E00")
    }
    
    static func tnmobileModalColor() -> UIColor {
        return UIColor(hexString: "000000").withAlphaComponent(0.44)
    }
    
    static func tnmobileLightGrey() -> UIColor {
        return UIColor(hexString: "B1B1B1")
    }
    
    static func tnmobileLightBlue() -> UIColor {
        return UIColor(hexString: "93B8CA")
    }
    
    static func tnmobileRed() -> UIColor {
        return UIColor(hexString: "D0021B")
    }
    
    static var oceanBlue: UIColor {
        return UIColor(hexString: "#037ba2")
    }
    
    static var turquoiseBlue : UIColor {
        return UIColor(hexString: "#07b2cf")
    }
}

