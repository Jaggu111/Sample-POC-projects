//
//  CoreDataStack.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import Foundation
import CoreData

protocol ManagedObjectContextDependentType {
    var managedObjectContext: NSManagedObjectContext! { get }
}

extension ManagedObjectContextDependentType {
    var managedObjectContext: NSManagedObjectContext {
        return appDelegate.mainContext
    }
}

func createMainContext() -> NSManagedObjectContext {
    // Initialize NSManagedObjectModel
    let modelURL = mainBundle.url(forResource: Constants.Global.activity.capitalized, withExtension: "momd")
    guard let model = NSManagedObjectModel(contentsOf: modelURL!) else {
        fatalError(Constants.Error.modelNotExist)
    }
    // Configure NSPersistentStore
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    let storeURL = URL.documetsURL.appendingPathComponent("\(Constants.CoreDataEntity.parkingHistory.rawValue).sqlite")
    
    //try! FileManager.default.removeItem(at: storeURL)
    
    try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    // Create and return ManagedObjectContext
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}

func Entity(for entityName: Constants.CoreDataEntity, in context: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName.rawValue.upperPrefix, in: context)
}

func insertNewObject(forEntityName entityName: Constants.CoreDataEntity, into context: NSManagedObjectContext) -> NSManagedObject {
    return NSEntityDescription.insertNewObject(forEntityName: entityName.rawValue.upperPrefix, into: context)
}
//
//func fetchRequest(forEntityName entityName: Constants.CoreDataEntity) -> NSFetchRequest<ParkingHistory> {
//    return NSFetchRequest<ParkingHistory>(entityName: entityName.rawValue.upperPrefix)
//}

func deleteManagedObjects() {
//    let fetchRequest = NSFetchRequest<ParkingHistory>(entityName: Constants.CoreDataEntity.parkingHistory.rawValue)
//    do {
//        let parkingHistory = try appDelegate.mainContext.fetch(fetchRequest)
//        for history in parkingHistory {
//            appDelegate.mainContext.delete(history)
//        }
//    } catch _ {}
}

extension URL {
    static var documetsURL: URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}
