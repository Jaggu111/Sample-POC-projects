//
//  Validator+TN.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

extension UIButton {
    
    /*Priority here defines how big the width of the button is. We need adjust the font, image and title EdgeInsets based on the priority*/
    func setParkmobileButton(withImage image: UIImage, withTitle title: String, andPriority priority: Int) {
        self.setImage(image, for: .normal)
        self.setTitle(title, for: .normal)
        if priority >= 1 {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: (-self.bounds.width/3)+20, bottom: 0, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: -2, left: (-self.bounds.width/3)+30, bottom: 0, right: 0)
            self.titleLabel?.font = UIFont(name: Constants.Font.openSansSemiBold, size: 14)
        } else {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: (-self.bounds.width/2)+20, bottom: 0, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: -2, left: (-self.bounds.width/2)+20, bottom: 0, right: 0)
            self.titleLabel?.font = UIFont(name: Constants.Font.openSansSemiBold, size: 12)
        }
        
        //we need the min. scale factor as we didn't specify the min. font size for the title
        self.titleLabel?.minimumScaleFactor = 0.1
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.tintColor = UIColor.tnmobileBlue()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
