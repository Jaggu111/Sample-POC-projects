//
//  OnboardingVM.swift
//  Bluprint
//
//  Created by Emily Priddy on 10/24/18.
//  Copyright © 2018 Bluprint. All rights reserved.
//


import Foundation

public class OnboardingViewModel: OnboardingViewModelType {
    //public var backgroundColor: UIColor
    
    
    // UI Properties
    public let mainString: String
    public let promptString: String
   // public var backgroundColor: UIColor
    public var categories: [String]
    public var selectedCategories: [String]
    public var selectedIndexes: Set<IndexPath>
   // let trackingController = TrackingController()
    
    init() {
        mainString = "Welcome to Bluprint"
        promptString = "What do you love to do? Just pick three things to get started!"
        //backgroundColor = UIColor.white
        categories = Array.init()
        selectedIndexes = Set<IndexPath>()
        //categories = Category.allCases.map { $0.rawValue }
        selectedCategories = Array.init()
    }
    
    public func saveSelectedCategoriesInUserDefaults() {
//        let defaults = UserDefaults.standard
//        defaults.set(true, forKey: "DidSyncAffinities")
//
//        for categoryIndex in selectedIndexes {
//            selectedCategories.append(categories[categoryIndex.row])
//            let categoryIdList = CategoryId().categoryIdList
//            if let categoryIdValue = categoryIdList[categories[categoryIndex.row]] {
//                BluprintAPIController().affinityToAPI(affinityId: categoryIdValue, completion: { success, _ in
//                    if !success {
//                        defaults.set(false, forKey: "DidSyncAffinities")
//                    }
//                })
//            }
//        }
//        trackingController.trackEventWithDict(eventName: "Onboarding - Completed", eventDict: ["SelectedCategories": selectedCategories])
//        defaults.set(selectedCategories, forKey: "SelectedCategories")
    }
    
    func readSelectedCategoriesFromUserDefaults() -> [String] {
//        let defaults = UserDefaults.standard
//        return defaults.stringArray(forKey: "SelectedCategories") ?? [String]()
    }
}
