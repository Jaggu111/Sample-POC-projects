//
//  LibraryCoordinator.swift
//  Bluprint
//
//  Created by Robert Cole on 10/29/18.
//  Copyright © 2018 Bluprint. All rights reserved.
//

import UIKit

public protocol LibraryUserStateDelegate: class {
    func userStateChange()
}

public class LibraryCoordinator: NavigationCoordinator {
    public var navRouter: NavRouterType
    public var piaRouter: PIARouterType
    
    public var isStarted: Bool = false
    let trackingController = TrackingController()
    public init(piaRouter: PIARouterType, navRouter: NavRouterType = DefaultNavRouter()) {
        self.piaRouter = piaRouter
        self.navRouter = navRouter
    }
    
    public func start() {
        guard !isStarted else {
            return
        }
        
        isStarted = true
        trackingController.trackEvent(eventName: "Navigation - Library")
//        if !UserDefaults.standard.bool(forKey: "UserStartedSneakPreview") {
//            if let userState = UserDefaults.standard.string(forKey: "user_state"), userState == "subscribed" {
//                trackingController.trackEvent(eventName: "Navigation - Library Subscribed")
//                showSubscriberLibrary()
//            } else {
//                trackingController.trackEvent(eventName: "Navigation - Library Sneak Preview")
//                showSneakPreviewLibrary()
//            }
//        } else {
            if let _ = UserDefaults.standard.string(forKey: "user_state") {
                trackingController.trackEvent(eventName: "Navigation - Library Subscribed")
                showLoggedInLibrary()
            } else {
                trackingController.trackEvent(eventName: "Navigation - Library Non-Subscribed")
                showNonLoggedInLibrary()
            }
//        }
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.postSignIn(_:)),
//                                               name: NSNotification.Name(rawValue: "signinnotification"), object: nil)
        
    }
    
    @objc func postSignIn(_ notification: NSNotification) {
        
        showLoggedInLibrary()
        
    }
    
    func showSneakPreviewLibrary() {
        let loginSelectorViewController = LoginSelectorPreSneakViewController.instantiate()
        
        loginSelectorViewController.title = "Library"
        
        loginSelectorViewController.tabBarItem = UITabBarItem(title: "LIBRARY", image: UIImage(named: "library"), tag: 2)

        loginSelectorViewController.tabBarItem.badgeValue = nil
        loginSelectorViewController.tabBarItem.badgeColor = ColorUtil().colorFromHex(hex: "9994C1")
        
        loginSelectorViewController.vcDelegate = self
        
        navRouter.push(loginSelectorViewController, animated: false, popHandler: nil)
    }
    
    func showNonLoggedInLibrary() {
        let loginSelectorViewController = LoginSelectorViewController.instantiate()
        
        loginSelectorViewController.title = "Library"
        
        loginSelectorViewController.tabBarItem = UITabBarItem(title: "LIBRARY", image: UIImage(named: "library"), tag: 2)
        loginSelectorViewController.tabBarItem.badgeValue = nil
        loginSelectorViewController.tabBarItem.badgeColor = ColorUtil().colorFromHex(hex: "9994C1")
        
        loginSelectorViewController.vcDelegate = self
        
        navRouter.push(loginSelectorViewController, animated: false, popHandler: nil)
    }
    
    func showLoggedInLibrary() {
        let loginSelectorViewController = MyLibraryViewController.instantiate()
        
        loginSelectorViewController.title = "Library"
        
        loginSelectorViewController.tabBarItem = UITabBarItem(title: "LIBRARY", image: UIImage(named: "library"), tag: 2)
        loginSelectorViewController.tabBarItem.badgeValue = nil
        loginSelectorViewController.tabBarItem.badgeColor = ColorUtil().colorFromHex(hex: "9994C1")
        
        loginSelectorViewController.vcDelegate = self
        
        navRouter.push(loginSelectorViewController, animated: false, popHandler: nil)
    }
    
    public func toPresentable() -> UIViewController {
        return navRouter.toPresentable()
    }
}

extension LibraryCoordinator: LibraryViewControllerDelegate {
    public func showVPEfromLibrary(playlistId: Int) {
        let viewModel = ViewModelFactory().createVPEViewModelFromCDP(playlistID: playlistId, episodeIndex: 0)
        let piaContent = VPEViewController.instantiate()
        piaContent.setup(viewModel: viewModel)
        piaRouter.presentInPIA(piaContent)
    }
}

//extension LibraryCoordinator: LibraryUserStateDelegate {
//    public func userStateChange() {
//        if let _ = UserDefaults.standard.string(forKey: "user_state") {
//            trackingController.trackEvent(eventName: "Navigation - Library Subscribed")
//            showLoggedInLibrary()
//        } else {
//            trackingController.trackEvent(eventName: "Navigation - Library Non-Subscribed")
//            showNonLoggedInLibrary()
//        }
//    }
//}
