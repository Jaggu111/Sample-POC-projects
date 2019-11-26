
import Foundation

public class LinkingCenter {
    public static var shared: LinkingCenter = LinkingCenter()
    internal var rootCoordinator: Coordinator?
    
    private init() {}
    
    public func dispatchLink(_ deepLink: DeepLink) {
       // rootCoordinator?.handleDeepLink(deepLink)
    }
}
