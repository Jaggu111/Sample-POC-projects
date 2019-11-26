//
//  CGRect.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

extension CGRect {
    public func subtract(_ rect: CGRect) -> CGRect {
        return CGRect(x: origin.x - rect.origin.x,
                      y: origin.y - rect.origin.y,
                      width: size.width - rect.size.width,
                      height: size.height - rect.size.height)
    }
    
    public func multiply(by percentage: CGFloat) -> CGRect {
        return CGRect(x: origin.x * percentage,
                      y: origin.y * percentage,
                      width: size.width * percentage,
                      height: size.height * percentage)
    }
}
