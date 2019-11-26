//
//  UIScreen.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

extension UIScreen {
    static var width: CGFloat {
        return main.bounds.size.width
    }
    
    static var height: CGFloat {
        return main.bounds.size.height
    }
}
