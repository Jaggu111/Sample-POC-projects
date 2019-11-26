//
//  Validator+TN.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedOutSide() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard(tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    public func onMainAsyncAfter(second: Double, action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + second) {
            action()
        }
    }
    
    public func onConcurrentAsync(withQos qos: DispatchQoS, action: @escaping () -> Void) {
        DispatchQueue(label: "com.parkmobile.concurrentBackgroundQueue", qos: qos, attributes: .concurrent).async {
            action()
        }
    }
    
    public func showAlert(withTitle title: String, andMessage message: String, andDefaultTitle defaultTitle: String, andCustomActions actions: [UIAlertAction]?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let customActions = actions {
            customActions.forEach({[weak alertController] in
                alertController?.addAction($0)})
        }
        let defaultAction = UIAlertAction(title: defaultTitle, style: actions == nil ? .cancel : .default, handler: nil)
        alertController.addAction(defaultAction)
        onMainAsync {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    public var hasSafeAreaBottom: Bool {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaInsets.bottom > 0.0
        } else {
            return false
        }
    }
    
    public var hasSafeArea: Bool {
        if #available(iOS 11.0, *) {
            return self.view.insetsLayoutMarginsFromSafeArea
        } else {
            return false
        }
    }
    
    public var hasSafeAreaTop: Bool {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaInsets.top > 0.0
        } else {
            return false
        }
    }
    
    public func topSafeArea() -> CGFloat {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.top
        } else {
            return 0.0
        }
    }
    
    public var bottomSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.bottom
        } else {
            return 0
        }
    }
}
