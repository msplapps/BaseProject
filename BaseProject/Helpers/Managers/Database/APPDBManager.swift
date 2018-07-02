//
//  AppDBManager.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import CoreData


enum MOCType {
    case main
    case child
    case inMemory
}

enum CoreDataSaveResult {
    
    case success
    case failure(NSError)
    
    public func error() -> NSError? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }
}
class APPDBManager {

    static let shared: APPDBManager = APPDBManager()

    // MARK: - Core Data stack
    private lazy var applicationDocumentsDirectory: String? = {
        guard let documentsDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                           FileManager.SearchPathDomainMask.userDomainMask,
                                                                           true).first else {
                                                                            Logger.log(message: "Not able to find Documents Directory", event: .warning)
                                                                            return nil
        }
        return documentsDirectory
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: "BaseProject", withExtension: "momd") else {
            Logger.log(message: "Not able to find Bundle URL for the xcdatamodel", event: .warning)
            return nil
        }
        guard let model = NSManagedObjectModel.init(contentsOf: modelURL) else {
            Logger.log(message: "Not able to find Managed Object Model", event: .warning)
            return nil
        }
        return model
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let model = self.managedObjectModel else {
            return nil
        }
        guard let documentDirectory = self.applicationDocumentsDirectory else {
            return nil
        }
        dprint(object: "Document Directory : \(documentDirectory)")
        let coordinator = NSPersistentStoreCoordinator.init(managedObjectModel: model)
        let url = URL.init(fileURLWithPath: documentDirectory).appendingPathComponent("BaseProject")
        Logger.log(message: "db url\(url)", event: .info)
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            let storeMetaData = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: url, options: options)
            let isPscCompatible = model.isConfiguration(withName: nil, compatibleWithStoreMetadata: storeMetaData)
        } catch {
             Logger.log(message: "Error while fetching store meta data", event: .error)
        }
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            var dict = [String: AnyObject]()
            let failureReason = "Failed to initialize the application's persistentStore"
            dict[NSLocalizedDescriptionKey] = failureReason as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: COREDATAErrorConstants.CoreDataErrorDomian, code: COREDATAErrorConstants.CoreDataErrorCode, userInfo: dict)
            Logger.log(message: "Error while creating PersistentStore. Error \(wrappedError), \(wrappedError.userInfo)", event: .error)
            
        }
        return coordinator
    }()
    
    private lazy var memoryResidentPSC: NSPersistentStoreCoordinator? = {
        guard let model = self.managedObjectModel else {
            return nil
        }
        let coordinator = NSPersistentStoreCoordinator.init(managedObjectModel: model)
        
        do {
            try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            let failureReason = "Failed to initialize the application's persistentStore"
            dict[NSLocalizedDescriptionKey] = failureReason as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: COREDATAErrorConstants.CoreDataErrorDomian, code: COREDATAErrorConstants.CoreDataErrorCode, userInfo: dict)
            Logger.log(message: "Error while creating PersistentStore. Error \(wrappedError), \(wrappedError.userInfo)", event: .error)

        }
        return coordinator
    }()
    
    
    lazy var mainMOC: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var memoryResidentMOC: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.memoryResidentPSC
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func save(with mocType: MOCType, wait: Bool = false, completion: ((CoreDataSaveResult) -> Void)? = nil) {
        
        let moc = self.getMoc(for: mocType)
        let block = {
            if moc.hasChanges {
                do {
                    try moc.save()
                    Logger.log(message: "Saving \(moc.name ?? "MainMOC")", event: .info)
                    completion?(CoreDataSaveResult.success)
                } catch {
                    let nserror = error as NSError
                    completion?(CoreDataSaveResult.failure(nserror))
                    Logger.log(message: "Error while Saving. Error - \(nserror), \(nserror.userInfo)", event: .error)
                }
            }
        }
        wait ? moc.performAndWait(block) : moc.perform(block)
    }
    
    func getManagedObject(for entity: String, withMocType mocType: MOCType) -> NSManagedObject? {
        
        let moc = self.getMoc(for: mocType)
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: moc)
        guard let vEntityDescription = entityDescription else {
            return nil
        }
        return NSManagedObject.init(entity: vEntityDescription, insertInto: moc)
    }
    
    func getMoc(for mocType: MOCType) -> NSManagedObjectContext {
        
        switch mocType {
        case .inMemory:
            return memoryResidentMOC
        default:
            return mainMOC
        }
    }
    
    func getPscToUpdateCatalogDate() {
        _ = persistentStoreCoordinator
    }
    
}
