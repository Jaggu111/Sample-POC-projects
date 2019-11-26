

import UIKit

public protocol NavRouterType: class, Presentable {
    func present(_ module: Presentable, animated: Bool)
    func push(_ module: Presentable, animated: Bool, popHandler: (() -> Void)?)
    func popModule(animated: Bool)
    func pushWithoutNavBar(_ module: Presentable, animated: Bool, popHandler: (() -> Void)?)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func setRootModule(_ module: Presentable, hideBar: Bool, animated: Bool)
    func popToRootModule(animated: Bool)
}
