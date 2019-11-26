////
////  DiscoverCoordinator.swift
////  Bluprint
////
////  Created by Robert Cole on 10/29/18.
////  Copyright © 2018 Bluprint. All rights reserved.
////
//
//import UIKit
//
//public protocol DiscoverViewModelFactory {
////    func retrieveExampleViewModel() -> ExampleViewModelType
////    func createVPEViewModelFromDiscover(playlistID: Int) -> VPEViewModelType
//}
//
//public class DiscoverCoordinator: NavigationCoordinator {
//    public var navRouter: NavRouterType
//    public var piaRouter: PIARouterType
//    private var searchCoordinator: SearchCoordinator?
//    public let viewModelFactory: CDPViewModelFactory!
//    var searchViewController: SearchViewController!
//    var cdpViewController: CDPViewController!
//    var splashScreen: SplashScreenViewController!
//    let trackingController = TrackingController()
//    
//    public var isStarted: Bool = false
//    public init(piaRouter: PIARouterType,
//                navRouter: NavRouterType = DefaultNavRouter(),
//                viewModelFactory: CDPViewModelFactory = ViewModelFactory()) {
//        self.piaRouter = piaRouter
//        self.navRouter = navRouter
//        self.viewModelFactory = viewModelFactory
//    }
//    
//    public func start() {
//        guard !isStarted else {
//            return
//        }
//        
//        isStarted = true
//        trackingController.trackEvent(eventName: "Navigation - Discover")
//        let discoverViewController = DiscoverGalleryViewController.instantiate()
//        discoverViewController.title = "Explore"
//        discoverViewController.tabBarItem = UITabBarItem(title: "EXPLORE", image: UIImage(named: "discover"), tag: 1)
//
//        // self.UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key, UIFont(name: "AvenirNext-Bold", size: 18.0), for: .normal)
//
//        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTouched))
//        discoverViewController.navigationItem.rightBarButtonItem = searchButton
//        
//        discoverViewController.vcDelegate = self
//        
//        navRouter.push(discoverViewController, animated: false, popHandler: nil)
//    }
//    
//    @objc func searchButtonTouched() {
//        let searchCoordinator = SearchCoordinator(piaRouter: piaRouter, navRouter: navRouter)
//        searchCoordinator.start()
//        self.searchCoordinator = searchCoordinator
//        searchViewController = SearchViewController.instantiate()
//    }
//    
//    public func toPresentable() -> UIViewController {
//        return navRouter.toPresentable()
//    }
//    
//    public func canHandleDeeplink(_ deepLink: DeepLink) -> Bool {
//        let params = deepLink.params
//        
//        guard params["q"] != nil || params["playlistId"] != nil  else {
//            return false
//        }
//        
//        return true
//    }
//    
//    public func handleDeepLink(_ deepLink: DeepLink) {
//        let params = deepLink.params
//        
//        guard params["q"] != nil || params["playlistId"] != nil else {
//            return
//        }
//        
//        start()
//
//        if let searchParameter = params["q"] as? String {
//            trackingController.trackEvent(eventName: "Navigation - Discover Search Open")
//            let searchResultsModel = SearchResultsViewModel(searchString: searchParameter, isFromTopic: true, type: nil, typeString: nil)
//            let searchResultsViewController = SearchResultsViewController.instantiate()
//            searchResultsViewController.setup(delegate: self, viewModel: searchResultsModel, isFilterHidden: true)
//            navRouter.pushWithoutNavBar(searchResultsViewController, animated: false, popHandler: nil)
//        }
//        
//        if let playlistId = params["playlistId"] as? String {
//            trackingController.trackEvent(eventName: "Navigation - CDP From Discover")
//            cdpViewController = CDPViewController.instantiate()
//            cdpViewController?.vcDelegate = self
//            cdpViewController.playlistId = Int(playlistId)
//            navRouter.pushWithoutNavBar(cdpViewController, animated: true, popHandler: nil)
//        }
//    }
//}
//
//extension DiscoverCoordinator: ExampleViewControllerDelegate, LoginSelectorViewDelegate {
//    
//    public func showExamplePIA() {
//        trackingController.trackEvent(eventName: "Navigation - VPE From Discover")
//        let viewModel = viewModelFactory.createVPEViewModelFromCDP(playlistID: 270, episodeIndex: 0)
//
//        let piaContent = VPEViewController.instantiate()
//
//        piaContent.setup(viewModel: viewModel)
//
//        piaRouter.presentInPIA(piaContent)
//    }
//    
//    public func showSearchView() {
//        let searchCoordinator = SearchCoordinator(piaRouter: piaRouter, navRouter: navRouter)
//        searchCoordinator.start()
//        self.searchCoordinator = searchCoordinator
////        searchViewController = SearchViewController.instantiate()
////        searchViewController?.delegate = self
////        navRouter.push(searchViewController, animated: true, popHandler: nil)
//    }
//
//    public func showCDPView() {
//        trackingController.trackEvent(eventName: "Navigation - CDP From Discover")
//        cdpViewController = CDPViewController.instantiate()
//        cdpViewController?.vcDelegate = self
//        navRouter.push(cdpViewController, animated: true, popHandler: nil)
//    }
//    
//    public func showSplashScreen() {
//        splashScreen = SplashScreenViewController.instantiate()
//        navRouter.push(splashScreen, animated: true, popHandler: nil)
//    }
//}
//
//extension DiscoverCoordinator: SearchViewControllerDelegate {
//    public func searchViewControllerDidSelect(searchTerm: String) {
//        //
//    }
//    
//    public func dismissSearchView() {
//        navRouter.popModule(animated: true)
//    }
//}
//
//extension DiscoverCoordinator: DiscoverViewControllerDelegate {
//    public func showSearchViewFromDiscover(searchText: String, type: String, typeString: String) {
//        trackingController.trackEvent(eventName: "Navigation - Discover Search Open")
//        let searchResultsModel = SearchResultsViewModel(searchString: searchText, isFromTopic: true, type: type, typeString: typeString)
//        let searchResultsViewController = SearchResultsViewController.instantiate()
//        searchResultsViewController.setup(delegate: self, viewModel: searchResultsModel, isFilterHidden: true)
//        navRouter.pushWithoutNavBar(searchResultsViewController, animated: false, popHandler: nil)
//    }
//}
//
//extension DiscoverCoordinator: CDPViewControllerDelegate {
//    public func showSearchViewFromCDP(searchText: String) {
//        trackingController.trackEvent(eventName: "Navigation - Search From CDP")
//        let searchResultsModel = SearchResultsViewModel(searchString: searchText, isFromTopic: false, type: nil, typeString: nil)
//        let searchResultsViewController = SearchResultsViewController.instantiate()
//        searchResultsViewController.setup(delegate: self, viewModel: searchResultsModel, isFilterHidden: false)
//        navRouter.pushWithoutNavBar(searchResultsViewController, animated: false, popHandler: nil)
//    }
//
//    public func showVPEFromCDP(playlistId: Int, episodeId: Int) {
//        trackingController.trackEvent(eventName: "Navigation - VPE From CDP")
//        let viewModel = viewModelFactory.createVPEViewModelFromCDP(playlistID: playlistId, episodeIndex: episodeId)
//        
//        let piaContent = VPEViewController.instantiate()
//        piaContent.setup(viewModel: viewModel)
//        piaRouter.presentInPIA(piaContent)
//    }
//}
//
//extension DiscoverCoordinator: SearchResultsViewControllerDelegate {
//    public func showCDPfromSearchResults(playlistId: Int) {
//        trackingController.trackEvent(eventName: "Navigation - Discover Search Complete")
//        let cdpViewController = CDPViewController.instantiate()
//        cdpViewController.vcDelegate = self
//        cdpViewController.playlistId = playlistId
//        navRouter.pushWithoutNavBar(cdpViewController, animated: true, popHandler: nil)
//    }
//    
//    public func dismissSearchResultsView() {
//        navRouter.popModule(animated: true)
//    }
//}
