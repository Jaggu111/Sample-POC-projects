

import UIKit

public class DefaultNavRouter: NSObject, NavRouterType {
    private var popHandlers: [UIViewController : () -> Void]
    private let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        self.popHandlers = [:]
        super.init()
        self.navigationController.delegate = self
    }
    
    public func toPresentable() -> UIViewController {
        return navigationController
    }
    
    public func present(_ module: Presentable, animated: Bool) {
        let controller = module.toPresentable()
        
        navigationController.present(controller, animated: animated, completion: nil)
    }
    
    public func dismissModule(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    public func push(_ module: Presentable, animated: Bool = true, popHandler: (() -> Void)? = nil) {
        // Avoid pushing UINavigationController onto stack
        let controller = module.toPresentable()
        
        guard controller is UINavigationController == false else {
                return
        }
        
        if let popHandler = popHandler {
            popHandlers[controller] = popHandler
        }
        
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func popModule(animated: Bool = true) {
        if let controller = navigationController.popViewController(animated: animated) {
            runPopHandler(for: controller)
        }
    }
    
    public func pushWithoutNavBar(_ module: Presentable, animated: Bool = true, popHandler: (() -> Void)? = nil) {
        // Avoid pushing UINavigationController onto stack
        let controller = module.toPresentable()
        
        guard controller is UINavigationController == false else {
            return
        }
        
        if let popHandler = popHandler {
            popHandlers[controller] = popHandler
        }
        
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func setRootModule(_ module: Presentable, hideBar: Bool, animated: Bool) {
        let controller = module.toPresentable()
        
        navigationController.viewControllers.reversed().forEach { runPopHandler(for: $0) }
        
        navigationController.isNavigationBarHidden = hideBar
        navigationController.setViewControllers([controller], animated: animated)
    }
    
    public func popToRootModule(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { runPopHandler(for: $0) }
        }
    }
    
    private func runPopHandler(for controller: UIViewController) {
        guard let popHandler = popHandlers[controller] else {
            return
        }
        popHandler()
        popHandlers.removeValue(forKey: controller)
    }
}

extension DefaultNavRouter: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        
        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController) else {
            return
        }
        
        runPopHandler(for: poppedViewController)
    }
}
