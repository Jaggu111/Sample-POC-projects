//
//  UIView+Extension.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /**
     add's corner radius to the view
    */
    func addMask(forRoundingCorners corners: UIRectCorner, withCornerRadius radius: Int) {
        let mask = CAShapeLayer()
        mask.bounds = self.frame
        mask.position = self.center
        mask.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = mask
    }
    
    func disable() {
        isUserInteractionEnabled = false
        backgroundColor = .lightGray
    }
    
    func enable(with color: UIColor) {
        isUserInteractionEnabled = true
        backgroundColor = color
    }
    
    func addDropShadow() {
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0.2, height: 0.8)
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach{addSubview($0)}
    }
}
