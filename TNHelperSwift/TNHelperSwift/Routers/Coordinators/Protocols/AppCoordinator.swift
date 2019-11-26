

import Foundation
import UIKit

class AppCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let vc = ViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func buySub() {
        let child = BuyCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func loginSub() {
           let vc = LoginViewController.instantiate()
           vc.coordinator = self
           navigationController.pushViewController(vc, animated: true)
       }
    
    func childDidFinsh(_ child: Coordinator?){
        for (index, coordinator) in
            childCoordinators.enumerated(){
                if coordinator === child {
                    childCoordinators.remove(at: index)
                    break
                }
            }
        }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController){
            return
        }
        
        if let buyViewController = fromViewController as? BUYViewController {
            childDidFinsh(buyViewController.coordinator)
        }
        
    }
    
}
