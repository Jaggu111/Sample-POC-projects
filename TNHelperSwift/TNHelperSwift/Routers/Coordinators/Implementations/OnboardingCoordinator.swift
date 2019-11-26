////
////  OnboardingCoordinator.swift
////  Bluprint
////
////  Created by Robert Cole on 10/30/18.
////  Copyright © 2018 Bluprint. All rights reserved.
////
//
//import UIKit
//
//public protocol OnboardingViewModelFactory {
//    func retrieveOnboardingViewModel() -> OnboardingViewModelType
//}
//
//public protocol OnboardingCoordinatorDelegate: class {
//    func onboardingDidComplete(for coordinator: OnboardingCoordinator?)
//}
//
//public class OnboardingCoordinator: NavigationCoordinator {
//    public weak var delegate: OnboardingCoordinatorDelegate?
//    
//    public var navRouter: NavRouterType
//    
//    public var isStarted: Bool = false
//    public let viewModelFactory: OnboardingViewModelFactory
//    let trackingController = TrackingController()
//    
//    public init(router: NavRouterType = DefaultNavRouter(),
//                delegate: OnboardingCoordinatorDelegate,
//                viewModelFactory: OnboardingViewModelFactory = ViewModelFactory()) {
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
//        trackingController.trackEvent(eventName: "Navigation - Onboarding")
//        let viewModel = viewModelFactory.retrieveOnboardingViewModel()
//        
//        let onboardingViewController = OnboardingViewController.instantiate()
//        onboardingViewController.setup(delegate: self, viewModel: viewModel)
//        
//        navRouter.setRootModule(onboardingViewController, hideBar: true, animated: false)
//    }
//    
//    public func toPresentable() -> UIViewController {
//        return navRouter.toPresentable()
//    }
//}
//
//extension OnboardingCoordinator: OnboardingViewControllerDelegate {
//    func onboardingDidComplete(for viewController: OnboardingViewController) {
//        delegate?.onboardingDidComplete(for: self)
//    }
//}
