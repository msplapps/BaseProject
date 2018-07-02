//
//  AppCatalougeSyncManager.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 27/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import UIKit

enum CatalogDataUpdateType: String {
    case photos = "photosLastUpdated"
    
}

class APPCatalougeSyncManager {
    
    var isPhotosUpdating: Bool = false
    
    
    let catalogQueue: DispatchQueue = DispatchQueue.global(qos: .utility)
    static let shared: APPCatalougeSyncManager = APPCatalougeSyncManager()
    
    private init() {
        
    }
    
    func isPhotosCatalogDataAvailable() -> Bool {
        let lastUpdated = UserDefaults.standard.value(forKey: CatalogDataUpdateType.photos.rawValue)
        return lastUpdated != nil
}
    
    func loadPhotoCatalogs(onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        if APPCatalougeSyncManager.shared.isPhotosUpdating {
            return
        }
        
        if isPhotosCatalogDataAvailable() {
            APPDBUtility.photosDataAvailability = .available
        } else {
            APPDBUtility.photosDataAvailability = .unavailable
        }
        
        let value = true
        
        if value {
            var backgroundTask = UIBackgroundTaskInvalid
            backgroundTask = APPCatalougeSyncManager.shared.beginBackgroundTask()
            APPCatalougeSyncManager.shared.isPhotosUpdating = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.PhotosUpdating),
                                            object: nil)
            
            dprint( object: "PHOTOS API call Started: \(Date())")
            Logger.log(message: "Calling Accessories Catalog Service API", event: .info)
            let photosDownloadStartDate = Date()
            let params = [String: Any]()
            
            
            AppDataManager.getPhotoData(parametes: params, onSuccess: { (response) in
                print("PHOTOS API response received: \(Date())")
                let elapsed = Date().timeIntervalSince(photosDownloadStartDate)
                Logger.log(message: "Photos Catalog Service API Succeeded, Download Time Taken: \(elapsed) seconds", event: .info)
                APPDBUtility.photosDataAvailability = .flushing
                APPDBUtility.resetAllPhotosDataEntities(mocType: .main)
                APPDBUtility.photosDataAvailability = .updating
                
                APPDBModel.savePhotoInDB(response, onSave: {
                    APPDBUtility.photosDataAvailability = .available
                    DispatchQueue.main.async {
                        APPDBUtil.updateLastUpdatedDateInUserDefaults(catalogType: .photos)
                        APPCatalougeSyncManager.shared.isPhotosUpdating = false
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.photosDataNotification),
                                                        object: nil)
                        onSuccess()
                        if backgroundTask != UIBackgroundTaskInvalid {
                            APPCatalougeSyncManager.shared.endBackgroundTask(taskId: backgroundTask)
                        }
                    }
                })
            }, onFailure: { (error) in
                APPCatalougeSyncManager.shared.isPhotosUpdating = false
                Logger.log(message: "\(error.statusMessage)", event: .error)
                DispatchQueue.main.async {
                    if APPDBUtility.photosDataAvailability == .unavailable {
                        NotificationCenter.default.post(
                            name: NSNotification.Name(rawValue: NOTIFICATION.photosUpdationFailedNotification),
                            object: nil)
                        onError(error.statusMessage)
                    } else {
                        onSuccess()
                    }
                    if backgroundTask != UIBackgroundTaskInvalid {
                        APPCatalougeSyncManager.shared.endBackgroundTask(taskId: backgroundTask)
                    }
                }
            })
            
            
            
            
//            POSDataManager.getAccessoryGridWallData(parametes: params, onSuccess: { (response) in
//                print("Accessories API response received: \(Date())")
//                let elapsed = Date().timeIntervalSince(accessoriesDownloadStartDate)
//                pos_info(POSAppLogKeys.overview, "Accessories Catalog Service API Succeeded, Download Time Taken: \(elapsed) seconds")
//                POSDBUtility.accessoryDataAvailablity = .flushing
//                POSDBUtility.resetAllAccessoriesDataEntities(mocType: .child)
//                POSDBUtility.accessoryDataAvailablity = .updating
//                POSDBAccessoryManager.saveAccessoryInDB(response, mocType: .child, onSave: {
//                    POSDBUtility.accessoryDataAvailablity = .available
//                    DispatchQueue.main.async {
//                        POSUtil.updateLastUpdatedDateInUserDefaults(catalogType: .accessory)
//                        POSCatalogSyncManager.shared.isAccessoryUpdating = false
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: POSAppNotifications.accessoryDataNotification),
//                                                        object: nil)
//                        onSuccess()
//                        if backgroundTask != UIBackgroundTaskInvalid {
//                            POSCatalogSyncManager.shared.endBackgroundTask(taskId: backgroundTask)
//                        }
//                    }
//                })
//
//            }) { (error) in
//                POSCatalogSyncManager.shared.isAccessoryUpdating = false
//                pos_error(POSLoggerKey.catalogSyncUpAccessories, "\(error.statusMessage)")
//                DispatchQueue.main.async {
//                    if POSDBUtility.accessoryDataAvailablity == .unavailable {
//                        NotificationCenter.default.post(
//                            name: NSNotification.Name(rawValue: POSAppNotifications.accessoryUpdationFailedNotification),
//                            object: nil)
//                        onError(error.statusMessage)
//                    } else {
//                        onSuccess()
//                    }
//                    if backgroundTask != UIBackgroundTaskInvalid {
//                        POSCatalogSyncManager.shared.endBackgroundTask(taskId: backgroundTask)
//                    }
//                }
//            }
        } else {
            onSuccess()
        }
    }
    
    func beginBackgroundTask() -> UIBackgroundTaskIdentifier {
        //Passing nil to expiration handler makes ios to kill app if time expires,
        //so that if coredata updation is unfinished, it will start all over again when app is relaunched
        return UIApplication.shared.beginBackgroundTask(expirationHandler: {

            Logger.log(message: "Intentionally crashed to start catalog sync-up all over again on next launch", event: .error)
            
        })
    }
    
    func endBackgroundTask(taskId: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(taskId)
    }

}
