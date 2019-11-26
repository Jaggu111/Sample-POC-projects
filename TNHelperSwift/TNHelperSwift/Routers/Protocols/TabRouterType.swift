
import UIKit

public protocol TabRouterType: class, Presentable {
    var viewControllers: [UIViewController] { get }
    func setTabs(using modules: [Presentable])
    func addTab(for module: Presentable)
    func selectTab(at index: Int)
    func selectTab(for module: Presentable)
}
