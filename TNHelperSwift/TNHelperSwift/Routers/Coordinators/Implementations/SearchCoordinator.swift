////
////  SearchCoordinator.swift
////  Bluprint
////
////  Created by Emily Priddy on 12/7/18.
////  Copyright © 2018 Bluprint. All rights reserved.
////
//
//import UIKit
//
//public class SearchCoordinator: NavigationCoordinator {
//    var navRouter: NavRouterType
//    public var piaRouter: PIARouterType
//    var searchController: SearchController?
//    private var searchViewController: SearchViewController?
//    private var searchResultsViewModel: SearchResultsViewModel?
//    private var searchResultsViewController: SearchResultsViewController?
//    let trackingController = TrackingController()
//    public var isStarted: Bool = false
//    
//    public init(piaRouter: PIARouterType,
//                navRouter: NavRouterType) {
//        self.navRouter = navRouter
//        self.piaRouter = piaRouter
//    }
//    
//    public func start() {
//        guard !isStarted else {
//            return
//        }
//        isStarted = true
//        trackingController.trackEvent(eventName: "Navigation - Search Open")
//        searchController = SearchController.init()
//        let searchViewController = SearchViewController.instantiate()
//        searchViewController.delegate = self
//        navRouter.pushWithoutNavBar(searchViewController, animated: false, popHandler: nil)
//        self.searchViewController = searchViewController
//    }
//    
//    public func toPresentable() -> UIViewController {
//        return navRouter.toPresentable()
//    }
//}
//
//extension SearchCoordinator: SearchViewControllerDelegate {
//    public func dismissSearchView() {
//        navRouter.popModule(animated: true)
//    }
//    
//    public func searchViewControllerDidSelect(searchTerm: String) {
//        trackingController.trackEvent(eventName: "Navigation - Search Filter Open")
//        let searchResultsModel = SearchResultsViewModel(searchString: searchTerm, isFromTopic: false, type: nil, typeString: nil)
//        let searchResultsViewController = SearchResultsViewController.instantiate()
//        searchResultsViewController.setup(delegate: self, viewModel: searchResultsModel, isFilterHidden: false)
//        navRouter.pushWithoutNavBar(searchResultsViewController, animated: true, popHandler: nil)
//        self.searchResultsViewController = searchResultsViewController
//        self.searchResultsViewModel = searchResultsModel
//    }
//}
//
//extension SearchCoordinator: SearchResultsViewControllerDelegate {
//    public func dismissSearchResultsView() {
//        navRouter.popModule(animated: true)
//    }
//    
//    public func showCDPfromSearchResults(playlistId: Int) {
//        trackingController.trackEvent(eventName: "Navigation - CDP From Search")
//        let cdpViewController = CDPViewController.instantiate()
//        cdpViewController.playlistId = playlistId
//        cdpViewController.vcDelegate = self
//        navRouter.pushWithoutNavBar(cdpViewController, animated: true, popHandler: nil)
//    }
//}
//
//extension SearchCoordinator: CDPViewControllerDelegate {
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
//        let viewModel = ViewModelFactory().createVPEViewModelFromCDP(playlistID: playlistId, episodeIndex: episodeId)
//        
//        let piaContent = VPEViewController.instantiate()
//        piaContent.setup(viewModel: viewModel)
//        piaRouter.presentInPIA(piaContent)
//    }
//    
//}
