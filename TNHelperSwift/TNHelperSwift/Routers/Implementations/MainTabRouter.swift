//
//  MainTabRouter.swift
//  Bluprint
//
//  Created by Robert Cole on 11/9/18.
//  Copyright © 2018 Bluprint. All rights reserved.
//

import UIKit

public protocol MainTabRouterViewModelFactory {
    func retrievePiaTabBarViewModel() -> PIATabBarViewModel
}

public class MainTabRouter: TabRouterType {
    private let tabBarController = PIATabBarController.instantiate()
    
    private let viewModelFactory: MainTabRouterViewModelFactory
    
    public init(viewModelFactory: MainTabRouterViewModelFactory = ViewModelFactory()) {
        self.viewModelFactory = viewModelFactory
        
        tabBarController.setup(viewModel: viewModelFactory.retrievePiaTabBarViewModel())
    }
    
    public var viewControllers: [UIViewController] {
        get {
            return tabBarController.viewControllers ?? []
        }
        set {
            tabBarController.viewControllers = newValue
        }
    }
    
    public func setTabs(using modules: [Presentable]) {
        var viewControllers = [UIViewController]()
        
        for module in modules {
            viewControllers.append(module.toPresentable())
        }
        
        self.viewControllers = viewControllers
    }
    
    public func addTab(for module: Presentable) {
        viewControllers.append(module.toPresentable())
    }
    
    public func selectTab(at index: Int) {
        tabBarController.selectedIndex = 0
    }
    
    public func selectTab(for module: Presentable) {
        tabBarController.selectedViewController = module.toPresentable()
    }
    
    public func toPresentable() -> UIViewController {
        return tabBarController
    }
}

extension MainTabRouter: PIARouterType {
    public func presentInPIA(_ content: PIAContent) {
        tabBarController.presentInPIA(content)
    }
    
    public func dismissPIA(direction: SwipeDirection) {
        tabBarController.dismissPIA(direction: direction)
    }
}
