//
//  APPDBCommon.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class APPDBCommon {

    
    /////////////////////////////////////////////USER DATA SAVING IN CORE DATA /////////////////////////////////////
    class func addOrUpdateUserDataintoCoreData(with data: JSON, mocType: MOCType = .main, onSuccess: @escaping (DBUser?) -> Void) {
        
        self.getUserDataFromDB(with: data["id"].int64Value, mocType: mocType) { (user) in
            var userObject = user
            if userObject == nil {
                userObject = APPDBManager.shared.getManagedObject(for: APPDBConstants.USER, withMocType: mocType) as? DBUser
            }
            if let userData = userObject {
                userData.id = data["id"].int64Value
                userData.email = data["email"].stringValue
                userData.name = data["name"].stringValue
                userData.phone = data["phone"].stringValue
                userData.username = data["username"].stringValue
                userData.website = data["website"].stringValue
                userData.lat = data["address"]["geo"]["lat"].doubleValue
                userData.lng = data["address"]["geo"]["lng"].doubleValue
                userData.city = data["address"]["city"].stringValue
                userData.street = data["address"]["street"].stringValue
                userData.suite = data["address"]["suite"].stringValue
                userData.zipcode = data["address"]["zipcode"].stringValue
            }
            onSuccess(userObject)
        }
    }

    
    private class func getUserDataFromDB(with userId: Int64, mocType: MOCType, onFetch: @escaping (DBUser?) -> Void) {
        let mainMOC = APPDBManager.shared.getMoc(for: mocType)
        mainMOC.performAndWait {
            let fetchRequest = NSFetchRequest<DBUser>.init(entityName: APPDBConstants.USER)
            fetchRequest.predicate = NSPredicate.init(format: "id == %d", userId)
            dprint(object: fetchRequest)
            do {
                let userList = try mainMOC.fetch(fetchRequest)
                let user = userList.isEmpty ? nil : userList.first
                onFetch(user)
            } catch let error as NSError {
                Logger.log(message: "APPDBCommon:getUserFromDB Could not fetch User. Error - \(error), \(error.userInfo)", event: .error)
                onFetch(nil)
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    /////////////////////////////////////////////ALBUM DATA SAVING IN CORE DATA /////////////////////////////////////
    class func addOrUpdateAlbumIntoCoreData(with data: JSON, mocType: MOCType = .main, onSuccess: @escaping (DBAlbum?) -> Void) {
        
        self.getAlbumDataFromDB(with: data["id"].int64Value, mocType: mocType) { (album) in
            var albumObject = album
            if albumObject == nil {
                albumObject = APPDBManager.shared.getManagedObject(for: APPDBConstants.ALBUM, withMocType: mocType) as? DBAlbum
            }
            if let albumData = albumObject {
                albumData.id = data["id"].int64Value
                albumData.userId = data["userId"].int64Value
                albumData.title = data["title"].stringValue
            }
            onSuccess(albumObject)
        }
    }
    
    
    private class func getAlbumDataFromDB(with albumId: Int64, mocType: MOCType, onFetch: @escaping (DBAlbum?) -> Void) {
        let mainMOC = APPDBManager.shared.getMoc(for: mocType)
        mainMOC.performAndWait {
            let fetchRequest = NSFetchRequest<DBAlbum>.init(entityName: APPDBConstants.ALBUM)
            fetchRequest.predicate = NSPredicate.init(format: "id == %d", albumId)
            do {
                let albumList = try mainMOC.fetch(fetchRequest)
                let album = albumList.isEmpty ? nil : albumList.first
                onFetch(album)
            } catch let error as NSError {
                Logger.log(message: "APPDBCommon:getAlbumFromDB Could not fetch Album. Error - \(error), \(error.userInfo)", event: .error)
                onFetch(nil)
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /////////////////////////////////////////////ALBUM DATA SAVING IN CORE DATA /////////////////////////////////////
    class func addOrUpdatePhotosIntoCoreData(with data: JSON, mocType: MOCType = .main, onSuccess: @escaping (DBPhoto?) -> Void) {
        self.getPhotoDataFromDB(with: data["id"].int64Value, mocType: mocType) { (photo) in
            var photoObject = photo
            if photoObject == nil {
                photoObject = APPDBManager.shared.getManagedObject(for: APPDBConstants.PHOTO, withMocType: mocType) as? DBPhoto
            }
            if let photoData = photoObject {
                photoData.albumId = data["albumId"].int64Value
                photoData.id = data["id"].int64Value
                photoData.title = data["title"].stringValue
                photoData.url = data["url"].stringValue
                photoData.thumbnailUrl = data["thumbnailUrl"].stringValue
            }
            onSuccess(photoObject)
        }
    }
    
    
    private class func getPhotoDataFromDB(with photoId: Int64, mocType: MOCType, onFetch: @escaping (DBPhoto?) -> Void) {
        let mainMOC = APPDBManager.shared.getMoc(for: mocType)
        mainMOC.performAndWait {
            let fetchRequest = NSFetchRequest<DBPhoto>.init(entityName: APPDBConstants.PHOTO)
            fetchRequest.predicate = NSPredicate.init(format: "id == %d", photoId)
            do {
                let photoList = try mainMOC.fetch(fetchRequest)
                let photo = photoList.isEmpty ? nil : photoList.first
                onFetch(photo)
            } catch let error as NSError {
                Logger.log(message: "APPDBCommon:getPhotoFromDB Could not fetch Photo. Error - \(error), \(error.userInfo)", event: .error)
                onFetch(nil)
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    


}
