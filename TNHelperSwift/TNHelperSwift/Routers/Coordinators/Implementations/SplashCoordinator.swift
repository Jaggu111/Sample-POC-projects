////
////  SplashCoordinator.swift
////  Bluprint
////
////  Created by Dusty Fields on 1/8/19.
////  Copyright © 2019 Bluprint. All rights reserved.
////
//
//import UIKit
//
//public protocol SplashScreenViewModelFactory {
//    func retrieveSplashScreenViewModel() -> SplashScreenViewModelType
//    func retrieveOnboardingViewModel() -> OnboardingViewModelType
//}
//
//public protocol SplashCoordinatorDelegate: class {
//    func displayOnboarding()
//    func displayPropositions()
//}
//
//public class SplashCoordinator: NavigationCoordinator {
//    public weak var delegate: OnboardingCoordinatorDelegate?
//    public weak var mainDelegate: OnboardingCoordinatorDelegate?
//    
//    public var navRouter: NavRouterType
//    
//    public var isStarted: Bool = false
//    public let viewModelFactory: SplashScreenViewModelFactory
//    let trackingController = TrackingController()
//    
//    public init(router: NavRouterType = DefaultNavRouter(),
//                delegate: OnboardingCoordinatorDelegate,
//                viewModelFactory: SplashScreenViewModelFactory = ViewModelFactory()) {
//        self.navRouter = router
//        self.delegate = delegate
//        self.viewModelFactory = viewModelFactory
//    }
//    
//    public func start() {
//        guard !isStarted else {
//            return
//        }
//        
//        isStarted = true
//        trackingController.trackEvent(eventName: "Navigation - Splash")
//        let viewModel = viewModelFactory.retrieveSplashScreenViewModel()
//        
//        let splashViewController = SplashScreenViewController.instantiate()
//        splashViewController.setup(delegate: self, viewModel: viewModel)
//        
//        navRouter.push(splashViewController, animated: true, popHandler: nil)
//    }
//    
//    public func toPresentable() -> UIViewController {
//        return navRouter.toPresentable()
//    }
//}
//
//extension SplashCoordinator: SplashCoordinatorDelegate {
//    public func displayOnboarding() {
//        trackingController.trackEvent(eventName: "Navigation - Onboarding")
//        let viewModel = viewModelFactory.retrieveOnboardingViewModel()
//        let onboardingViewController = OnboardingViewController.instantiate()
//        onboardingViewController.setup(delegate: self, viewModel: viewModel)
//
//        navRouter.setRootModule(onboardingViewController, hideBar: true, animated: false)
//    }
//    
//    public func displayPropositions() {
//        let propsViewController = PropostionViewController.instantiate()
//        navRouter.setRootModule(propsViewController, hideBar: true, animated: true)
//    }
//}
//
//extension SplashCoordinator: OnboardingViewControllerDelegate {
//    func onboardingDidComplete(for viewController: OnboardingViewController) {
//        delegate?.onboardingDidComplete(for: nil)
//    }
//
//    public func onboardingDidComplete(for coordinator: OnboardingCoordinator) {
//
//    }
//}
