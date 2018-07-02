//
//  APPDBUtility.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import CoreData


class APPDBUtility {

    ////////////////////////GET DATA FROM DB////////////////////////////
    
    class func getAlbumsData(userId: Int64?, searchText: String?, mocType: MOCType,
                             limit: Int? = nil, offset: Int? = nil) -> [DBAlbum]? {
        
        let moc = APPDBManager.shared.getMoc(for: mocType)
        let fetchRequest = NSFetchRequest<DBAlbum>.init(entityName: APPDBConstants.ALBUM)
        
//        if let text = searchText {
//            let albumPred = NSPredicate(format: "ANY title contains[c] %@", text)
//            fetchRequest.predicate = albumPred
//        }
        
        if let userId = userId {
            let albumPred = NSPredicate(format: "userId == %d", userId)
            let pred = fetchRequest.predicate
            if let predicate = pred {
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, albumPred])
            } else {
                fetchRequest.predicate = albumPred
            }
        }
        
        
        if let reqLimit = limit, let reqOffset = offset {
            fetchRequest.fetchOffset = reqOffset
            fetchRequest.fetchLimit = reqLimit
        }
        do {
            let sort = NSSortDescriptor(key: #keyPath(DBAlbum.id), ascending: true)
            fetchRequest.sortDescriptors = [sort]
            let albumList: [DBAlbum] = try moc.fetch(fetchRequest)
            return albumList.isEmpty ? nil : albumList
        } catch let error as NSError {
            Logger.log(message: "getAlbumData Could not get Album Data from DB. Error - \(error), \(error.userInfo)", event: .error)
        }
        return nil
    }
    
    
    class func getPhotosData(albumId: Int64?, searchText: String?, mocType: MOCType,
                             limit: Int? = nil, offset: Int? = nil) -> [DBPhoto]? {
        
        let moc = APPDBManager.shared.getMoc(for: mocType)
        let fetchRequest = NSFetchRequest<DBPhoto>.init(entityName: APPDBConstants.PHOTO)
        
        //        if let text = searchText {
        //            let albumPred = NSPredicate(format: "ANY title contains[c] %@", text)
        //            fetchRequest.predicate = albumPred
        //        }
        
        if let albumId = albumId {
            let photoPred = NSPredicate(format: "albumId == %d", albumId)
            let pred = fetchRequest.predicate
            if let predicate = pred {
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, photoPred])
            } else {
                fetchRequest.predicate = photoPred
            }
        }
        
        
        if let reqLimit = limit, let reqOffset = offset {
            fetchRequest.fetchOffset = reqOffset
            fetchRequest.fetchLimit = reqLimit
        }
        do {
            let sort = NSSortDescriptor(key: #keyPath(DBAlbum.id), ascending: true)
            fetchRequest.sortDescriptors = [sort]
            let photoList: [DBPhoto] = try moc.fetch(fetchRequest)
            return photoList.isEmpty ? nil : photoList
        } catch let error as NSError {
            Logger.log(message: "getAlbumData Could not get Photo Data from DB. Error - \(error), \(error.userInfo)", event: .error)
        }
        return nil
    }
    
    

}
