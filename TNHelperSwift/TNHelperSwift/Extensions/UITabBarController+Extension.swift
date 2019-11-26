//
//  Validator+TN.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    public var badgeCount: Int? {
        get {
            return tabBar.items?.first?.badgeValue?.intValue
        }
        set {
            if newValue == nil || newValue == 0 {
                tabBar.items?.first?.badgeValue = nil
            } else {
                tabBar.items?.first?.badgeValue = newValue?.description
                
                if #available(iOS 10.0, *) {
                    tabBar.items?.first?.badgeColor = UIColor.tnmobileBlue()
                    guard let boldFont = UIFont(name: Constants.Font.openSansBold, size: 12) else { return }
                    tabBar.items?.first?.setBadgeTextAttributes([NSAttributedString.Key.font: boldFont], for: .normal)
                }
            }
        }
    }
}
