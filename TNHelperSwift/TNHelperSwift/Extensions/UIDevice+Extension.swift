//
//  Validator+TN.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

enum DeviceType {
    case iPhoneXSeries, iPhone5Series, iPhoneRegularSeries, iPhoneRegularPlusSeries, iPad
    case unKnown
}

extension UIDevice {
    func type() -> DeviceType {
        var deviceType = DeviceType.unKnown
        if self.userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                deviceType = .iPhone5Series
            case 1334:
                deviceType = .iPhoneRegularSeries
            case 2208:
                deviceType = .iPhoneRegularPlusSeries
            case 2436:
                deviceType = .iPhoneXSeries
            default:
                deviceType = .unKnown
            }
        } else if self.userInterfaceIdiom == .pad {
            deviceType = .iPad
        }
        return deviceType
    }
    
    var isIphone5Series: Bool {
        return type() == .iPhone5Series
    }
    
    static var isLandscape: Bool {
        return current.orientation == .landscapeLeft || current.orientation == .landscapeRight
    }
    
    static var isPad: Bool {
        return current.userInterfaceIdiom == .pad
    }
    
    static var isPhone: Bool {
        return current.userInterfaceIdiom == .phone
    }
}
