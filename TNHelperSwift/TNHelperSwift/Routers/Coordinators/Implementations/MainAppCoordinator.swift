//
//  MainAppCoordinator.swift
//  Bluprint
//
//  Created by Robert Cole on 10/29/18.
//  Copyright © 2018 Bluprint. All rights reserved.
//

import UIKit

public protocol AppCoordinatorFactory {

}

// Used to make this more testable
public protocol Window {
    var rootViewController: UIViewController? { get set }
    
    func makeKeyAndVisible()
}

extension UIWindow: Window {}

public class MainAppCoordinator: AppCoordinator {
    public var window: Window
    public var isStarted: Bool = false
    
    // Placeholder, when replacing this the MainAppCoordinatorTests will need to be modified as well
    internal var onboardingIsNeeded: Bool = false
    
    private let navRouter: NavRouterType
    private let coordinatorFactory: AppCoordinatorFactory
    private var postOnboardingCoordinator: Coordinator?
    
    //let trackingController = TrackingController()
    private var onboardingCoordinator: Coordinator?
    let userDefaults = UserDefaults.standard
    
    public init(window: Window,
                coordinatorFactory: AppCoordinatorFactory = CoordinatorFactory(),
                navRouter: NavRouterType = DefaultNavRouter()) {
        self.window = window
        self.coordinatorFactory = coordinatorFactory
        self.navRouter = navRouter
//        postOnboardingCoordinator = coordinatorFactory.createPostOnboardingCoordinator()
    }
    
    public func start() {
        
    
        
    }
    
    func startup() {
        
    }
    
    // handle notification
    @objc func showOnBoarding(_ notification: NSNotification) {
    
    }
    
    @objc func showOnBoardingAfterSignup(_ notification: NSNotification) {
     
    }
    
    public func toPresentable() -> UIViewController {
        guard let rootViewController = window.rootViewController else {
            return UIViewController()
        }
        
        return rootViewController
    }
    
    public func canHandleDeeplink(_ deepLink: DeepLink) -> Bool {
        return postOnboardingCoordinator?.canHandleDeeplink(deepLink) ?? false
    }
    
    public func handleDeepLink(_ deepLink: DeepLink) {
        guard canHandleDeeplink(deepLink) else {
            return
        }
        
        start()
        
        postOnboardingCoordinator?.handleDeepLink(deepLink)
    }
}

//extension MainAppCoordinator: OnboardingCoordinatorDelegate {
//    public func onboardingDidComplete(for coordinator: OnboardingCoordinator?) {
//        // onboardingIsNeeded = true
//        postOnboardingCoordinator = coordinatorFactory.createPostOnboardingCoordinator()
//
//        trackingController.trackEvent(eventName: "Navigation - Post Onboarding")
//        userDefaults.set(true, forKey: "onBoardingCheck")
//
//        postOnboardingCoordinator?.start()
//
//        if let postOnboardingCoordinator = postOnboardingCoordinator {
//            navRouter.setRootModule(postOnboardingCoordinator, hideBar: true, animated: true)
//        }
//
//        onboardingCoordinator = nil
//    }
//}
//
//extension MainAppCoordinator: SplashCoordinatorDelegate {
//    public func displayOnboarding() {
//
//    }
//
//    public func displayPropositions() {
//
//    }
//}
