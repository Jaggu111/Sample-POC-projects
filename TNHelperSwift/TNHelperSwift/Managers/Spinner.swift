//
//  Spinner.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

/**
 Global spinner class which handles @P animations
 */
class Spinner {
    
    static private var spinningWindow = UIWindow(frame: UIScreen.main.bounds)
    static private let spinnerViewController = SpinnerViewController()
    
    static func startSpinning() {
        onMainAsync {
            set(newRootViewController: spinnerViewController)
            spinnerViewController.startAnimation()
        }
    }
    
    static func stopSpinning() {
        onMainAsync {
            spinnerViewController.stopAnimation()
            dismissRootViewController()
        }
    }
    
    static private func set(newRootViewController: UIViewController) {
        dismissRootViewController(hideWindow: false)
        spinningWindow.rootViewController = newRootViewController
        spinningWindow.windowLevel = .statusBar
        spinningWindow.makeKeyAndVisible()
        spinningWindow.rootViewController?.view.accessibilityViewIsModal = true
    }
    
    static private func dismissRootViewController(hideWindow: Bool = true) {
        spinningWindow.rootViewController?.dismiss(animated: false, completion: nil)
        spinningWindow.isHidden = hideWindow
    }
}
