//
//  LoadingOverlay.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

public class ActivityOverlay {
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var contentView = UIView()
    
    class var shared: ActivityOverlay {
        struct Static {
            static let instance: ActivityOverlay = ActivityOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        
        contentView.frame = view.frame
        contentView.backgroundColor =  self.UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        contentView.addSubview(overlayView)
        contentView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleHeight, .flexibleWidth]
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = view.center
        overlayView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        overlayView.backgroundColor = self.UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(contentView)
        self.activityIndicator.startAnimating()
        
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        contentView.removeFromSuperview()
    }
    
    func UIColorFromHex(rgbValue: UInt32, alpha: Double=1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}
