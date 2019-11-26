

import Foundation
import UIKit

class BuyCoordinator: Coordinator {
    
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
       
       init(navigationController: UINavigationController) {
           self.navigationController = navigationController
       }
    func start() {
         let vc = BUYViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
     }
    
//    func didFinsish(){
//        parentCoordinator?.childDidFinsh(self)
//    }
}
