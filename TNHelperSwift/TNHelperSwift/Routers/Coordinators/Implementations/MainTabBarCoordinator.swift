//
//  MainTabBarCoordinator.swift
//  Bluprint
//
//  Created by Robert Cole on 10/29/18.
//  Copyright © 2018 Bluprint. All rights reserved.
//

import UIKit

public protocol TabBarCoordinatorFactory {
    func createCoordinatorForTabs(piaRouter: PIARouterType) -> [Coordinator]
}

public class MainTabBarCoordinator: NSObject, TabBarCoordinator {
    public var tabRouter: TabRouterType
    public var piaRouter: PIARouterType
    
    public var isStarted = false
    
    private var childCoordinators: [Coordinator]
    
    public init(mainRouter: TabRouterType & PIARouterType = MainTabRouter(),
                coordinatorFactory: TabBarCoordinatorFactory = CoordinatorFactory()) {
        self.tabRouter = mainRouter
        self.piaRouter = mainRouter
        
        childCoordinators = coordinatorFactory.createCoordinatorForTabs(piaRouter: mainRouter)
        
        super.init()
    }
    
    public func start() {
        guard !isStarted else {
            return
        }
        
        isStarted = true
        
        tabRouter.setTabs(using: childCoordinators)
        
        childCoordinators.forEach {
            $0.start()
            
        }
    }
    
    public func toPresentable() -> UIViewController {
        return tabRouter.toPresentable()
    }
    
    public func canHandleDeeplink(_ deepLink: DeepLink) -> Bool {
        for coordinator in childCoordinators {
            if coordinator.canHandleDeeplink(deepLink) {
                return true
            }
        }
        
        return false
    }
    
    public func handleDeepLink(_ deepLink: DeepLink) {
        for coordinator in childCoordinators {
            if coordinator.canHandleDeeplink(deepLink) {
                start()
                coordinator.handleDeepLink(deepLink)
                tabRouter.selectTab(for: coordinator)
                break
            }
        }
    }
}
