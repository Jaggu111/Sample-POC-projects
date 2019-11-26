//
//  HomeNavigationController.swift
//  Bluprint
//
//  Created by Robert Cole on 10/29/18.
//  Copyright © 2018 Bluprint. All rights reserved.
//

import UIKit

public protocol HomeViewModelFactory {
    func retrieveHomeViewModel() -> HomeViewModelType
    func createVPEViewModel(playlistID: Int) -> VPEViewModelType
}

public class HomeCoordinator: NavigationCoordinator {
    public var navRouter: NavRouterType
    public var piaRouter: PIARouterType
    private var searchCoordinator: SearchCoordinator?
    var searchViewController: SearchViewController!
    var homeViewController: HomeViewController!
    let trackingController = TrackingController()
    public var isStarted: Bool = false
    public let viewModelFactory: HomeViewModelFactory
  
    public init(piaRouter: PIARouterType,
                navRouter: NavRouterType = DefaultNavRouter(),
                viewModelFactory: HomeViewModelFactory = ViewModelFactory()) {
        self.piaRouter = piaRouter
        self.navRouter = navRouter
        self.viewModelFactory = viewModelFactory
    }
    
    public func start() {
        guard !isStarted else {
            return
        }
        
        isStarted = true
        trackingController.trackEvent(eventName: "Navigation - Home")
        let viewModel = viewModelFactory.retrieveHomeViewModel()
        
        homeViewController = HomeViewController.instantiate()
        homeViewController.setup(viewModel: viewModel)
        
        homeViewController.navigationItem.titleView = UIImageView(image: UIImage(named: "bluprintLogoWhite"))
        homeViewController.tabBarItem = UITabBarItem(title: "HOME", image: UIImage(named: "home"), tag: 0)
        
        let remoteController = RemoteConfigController()
        if remoteController.remoteConfig.canShowSearchOnHome {
            let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTouched))
            homeViewController.navigationItem.rightBarButtonItem = searchButton
        }
        
        homeViewController.vcDelegate = self
        
        navRouter.push(homeViewController, animated: false, popHandler: nil)
    }
    
    public func toPresentable() -> UIViewController {
        return navRouter.toPresentable()
    }
    
    @objc func searchButtonTouched() {
        let searchCoordinator = SearchCoordinator(piaRouter: piaRouter, navRouter: navRouter)
        searchCoordinator.start()
        self.searchCoordinator = searchCoordinator
        searchViewController = SearchViewController.instantiate()
    }
}

extension HomeCoordinator: ExampleTableViewControllerDelegate {
    public func showExamplePIA() {
        let viewModel = viewModelFactory.createVPEViewModel(playlistID: 270)
        
        let piaContent = VPEViewController.instantiate()
        
        piaContent.setup(viewModel: viewModel)
        
        piaRouter.presentInPIA(piaContent)
    }
}

extension HomeCoordinator: HomeViewControllerDelegate {
    
    public func showSearchFromHome(searchTerm: String, isFromTopic: Bool) {
        trackingController.trackEvent(eventName: "Navigation - Search From Home")
        let searchResultsModel = SearchResultsViewModel(searchString: searchTerm, isFromTopic: isFromTopic, type: nil, typeString: nil)
        let searchResultsViewController = SearchResultsViewController.instantiate()
        searchResultsViewController.setup(delegate: self, viewModel: searchResultsModel, isFilterHidden: false)
        navRouter.pushWithoutNavBar(searchResultsViewController, animated: false, popHandler: nil)
    }
    
    public func showCDPfromHome(playlistId: Int) {
        trackingController.trackEvent(eventName: "Navigation - CDP From Home")
        let cdpViewController = CDPViewController.instantiate()
        cdpViewController.vcDelegate = self
        cdpViewController.playlistId = playlistId
        navRouter.pushWithoutNavBar(cdpViewController, animated: false, popHandler: nil)
    }
    
    public func showVPEfromHome(playlistId: Int) {
        trackingController.trackEvent(eventName: "Navigation - VPE From Home")
        let viewModel = ViewModelFactory().createVPEViewModelFromCDP(playlistID: playlistId, episodeIndex: 0)
        let piaContent = VPEViewController.instantiate()
        piaContent.setup(viewModel: viewModel)
        piaRouter.presentInPIA(piaContent)
    }
}

extension HomeCoordinator: SearchViewControllerDelegate {
    public func dismissSearchView() {
        navRouter.popModule(animated: true)
    }
    
    public func searchViewControllerDidSelect(searchTerm: String) {
        //
    }
}

extension HomeCoordinator: SearchResultsViewControllerDelegate {
    public func showCDPfromSearchResults(playlistId: Int) {
        let cdpViewController = CDPViewController.instantiate()
        cdpViewController.vcDelegate = self
        cdpViewController.playlistId = playlistId
        navRouter.pushWithoutNavBar(cdpViewController, animated: true, popHandler: nil)
    }
    
    public func dismissSearchResultsView() {
        navRouter.popModule(animated: true)
    }
}

extension HomeCoordinator: CDPViewControllerDelegate {
    public func showSearchViewFromCDP(searchText: String) {
        trackingController.trackEvent(eventName: "Navigation - Search From CDP")
        let searchResultsModel = SearchResultsViewModel(searchString: searchText, isFromTopic: false, type: nil, typeString: nil)
        let searchResultsViewController = SearchResultsViewController.instantiate()
        searchResultsViewController.setup(delegate: self, viewModel: searchResultsModel, isFilterHidden: false)
        navRouter.pushWithoutNavBar(searchResultsViewController, animated: false, popHandler: nil)
    }
    
    public func showVPEFromCDP(playlistId: Int, episodeId: Int) {
        let viewModel = ViewModelFactory().createVPEViewModelFromCDP(playlistID: playlistId, episodeIndex: episodeId)
        
        let piaContent = VPEViewController.instantiate()
        piaContent.setup(viewModel: viewModel)
        piaRouter.presentInPIA(piaContent)
    }

}
