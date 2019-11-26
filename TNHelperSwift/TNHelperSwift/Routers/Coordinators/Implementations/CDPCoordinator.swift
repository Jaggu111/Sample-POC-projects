////
////  CDPCoordinator.swift
////  Bluprint
////
////  Created by Dusty Fields on 12/10/18.
////  Copyright © 2018 Bluprint. All rights reserved.
////
//
//import UIKit
//
//public protocol CDPViewModelFactory {
//    func retrieveCDPViewModel() -> CDPViewModelType
//    func createVPEViewModelFromCDP(playlistID: Int, episodeIndex: Int) -> VPEViewModelType
//}
//
//public class CDPCoordinator: NavigationCoordinator {
//    public var navRouter: NavRouterType
//    public var piaRouter: PIARouterType
//    
//    public let viewModelFactory: CDPViewModelFactory
//    var searchViewController: SearchViewController!
//    
//    public var isStarted: Bool = false
//    let trackingController = TrackingController()
//        
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
//        trackingController.trackEvent(eventName: "Navigation - CDP")
//        let cdpViewController = CDPViewController.instantiate()
//        cdpViewController.vcDelegate = self
//        navRouter.pushWithoutNavBar(cdpViewController, animated: false, popHandler: nil)
//    }
//    
//    public func toPresentable() -> UIViewController {
//        return navRouter.toPresentable()
//    }
//    
//    public func canHandleDeeplink(_ deepLink: DeepLink) -> Bool {
//        let params = deepLink.params
//        
//        guard params["playlist_id"] != nil && params["+clicked_branch_link"] != nil else {
//            return false
//        }
//        
//        return true
//    }
//    
//    public func handleDeepLink(_ deepLink: DeepLink) {
//        let params = deepLink.params
//        
//        guard let playlistID = params["playlist_id"], params["+clicked_branch_link"] != nil else {
//            return
//        }
//        
//        start()
//        let cdpViewController = CDPViewController.instantiate()
//        
//        navRouter.push(cdpViewController, animated: false, popHandler: nil)
//        
//        SharedAlerts().showStandardAlert(title: "Deep Link Received",
//                                         message: "playlistID: \(playlistID)",
//                                         buttonText: "OK",
//                                         view: cdpViewController)
//    }
//}
//
//extension CDPCoordinator: SearchResultsViewControllerDelegate {
//    public func showCDPfromSearchResults(playlistId: Int) {
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
//
//extension CDPCoordinator: CDPViewControllerDelegate {
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
//        let cdpViewController = CDPViewController.instantiate()
//        cdpViewController.playlistId = playlistId
//        navRouter.pushWithoutNavBar(cdpViewController, animated: true, popHandler: nil)
//    }
//    
//    
//}
//
////extension CDPCoordinator: SearchViewControllerDelegate {
////    public func dismissSearchView() {
////        navRouter.popModule(animated: true)
////    }
////    
////    public func searchViewControllerDidSelect(searchTerm: String) {
////        let searchResultsModel = SearchResultsViewModel(searchString: searchTerm)
////        let searchResultsViewController = SearchResultsViewController.instantiate()
////        searchResultsViewController.setup(delegate: self, viewModel: searchResultsModel)
////        navRouter.pushWithoutNavBar(searchResultsViewController, animated: true, popHandler: nil)
////        self.searchResultsViewController = searchResultsViewController
////    }
////}
