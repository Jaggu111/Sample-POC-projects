

import Foundation
import UIKit

public protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    //var isStarted: Bool { get }
    
    func start()
    
   // func canHandleDeeplink(_ deepLink: DeepLink) -> Bool

  //  func handleDeepLink(_ deepLink: DeepLink)
}

//extension Coordinator {
//    public func canHandleDeeplink(_ deepLink: DeepLink) -> Bool {
//        return false
//    }
//
//    public func handleDeepLink(_ deepLink: DeepLink) {}
//}
