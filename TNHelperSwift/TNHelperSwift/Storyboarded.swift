

import UIKit

public protocol Storyboarded {
    
    static func instantiate() -> Self
}

public extension Storyboarded where Self: UIViewController {
     static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
