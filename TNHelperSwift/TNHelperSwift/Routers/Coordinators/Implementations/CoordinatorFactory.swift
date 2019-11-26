//
//  CoordinatorFactory.swift
//  Bluprint
//
//  Created by Robert Cole on 11/21/18.
//  Copyright © 2018 Bluprint. All rights reserved.
//

import Foundation

public class CoordinatorFactory {
    public init() {}
}

extension CoordinatorFactory: AppCoordinatorFactory {
    public func createOnboardingCoordinator(navRouter: NavRouterType, delegate: OnboardingCoordinatorDelegate) -> Coordinator {
        return OnboardingCoordinator(router: navRouter, delegate: delegate)
    }

    public func createSplashScreenCoordinator(navRouter: NavRouterType, delegate: OnboardingCoordinatorDelegate) -> Coordinator {
        return SplashCoordinator(router: navRouter, delegate: delegate)
    }
    
    public func createPostOnboardingCoordinator() -> Coordinator {
        return MainTabBarCoordinator()
    }
}

extension CoordinatorFactory: TabBarCoordinatorFactory {
    public func createCoordinatorForTabs(piaRouter: PIARouterType) -> [Coordinator] {
        return [HomeCoordinator(piaRouter: piaRouter),
                DiscoverCoordinator(piaRouter: piaRouter),
                LibraryCoordinator(piaRouter: piaRouter)]
    }
}
