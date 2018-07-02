//
//  APPDBModel.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import SwiftyJSON

class APPDBModel {

    // MARK: - Save User In CoreData
    class func saveUserInDB(_ userJson: JSON, mocType: MOCType = .main) {
        dprint(object: "USER Parsing started: \(Date())")
        Logger.log(message: "Coredata User Parsing started", event: .info)
        var userCount = 0
        let parseStartDate = Date()
        for user: JSON in userJson.arrayValue {
            userCount += 1
            APPDBCommon.addOrUpdateUserDataintoCoreData(with: user, onSuccess: { (dbUser) in
                guard let dbUserObj = dbUser else {
                    return
                }
                dprint(object: dbUserObj)
            })
        }
        APPDBManager.shared.save(with: mocType, wait: true)
        let elapsed = Date().timeIntervalSince(parseStartDate)
        Logger.log(message: "Parsing Done, Total Users: \(userCount), Parsing Time: \(elapsed) seconds", event: .info)
        dprint(object: "USER Parsing Ended: \(Date()), Parsing Time: \(elapsed) seconds")
        
    }
    
     // MARK: - Save Album In CoreData

    class func saveAlbumInDB(_ albumJSON: JSON, mocType: MOCType = .main) {
        dprint(object: "Album Parsing started: \(Date())")
        Logger.log(message: "Coredata Album Parsing started", event: .info)
        var albumCount = 0
        let parseStartDate = Date()
        for album: JSON in albumJSON.arrayValue {
            albumCount += 1
            APPDBCommon.addOrUpdateAlbumIntoCoreData(with: album, onSuccess: { (dbAlbum) in
                guard let dbAlbumObj = dbAlbum else {
                    return
                }
                dprint(object: dbAlbumObj)
            })
        }
        APPDBManager.shared.save(with: mocType, wait: true)
        let elapsed = Date().timeIntervalSince(parseStartDate)
        Logger.log(message: "Parsing Done, Total Albums: \(albumCount), Parsing Time: \(elapsed) seconds", event: .info)
        dprint(object: "Album Parsing Ended: \(Date()), Parsing Time: \(elapsed) seconds")
        
    }
    
    // MARK: - Save Photo In CoreData
    
    class func savePhotoInDB(_ photoJSON: JSON, mocType: MOCType = .main, onSuccess: @escaping (Bool) -> Void) {
        dprint(object: "Photo Parsing started: \(Date())")
        Logger.log(message: "Coredata Photo Parsing started", event: .info)
        var photoCount = 0
        let parseStartDate = Date()
        for photo: JSON in photoJSON.arrayValue {
            photoCount += 1
            APPDBCommon.addOrUpdatePhotosIntoCoreData(with: photo, onSuccess: { (dbPhoto) in
                guard let dbPhotoObj = dbPhoto else {
                    return
                }
                dprint(object: dbPhotoObj)
            })
        }
        APPDBManager.shared.save(with: mocType, wait: true)
        let elapsed = Date().timeIntervalSince(parseStartDate)
        Logger.log(message: "Parsing Done, Total Photos: \(photoCount), Parsing Time: \(elapsed) seconds", event: .info)
        dprint(object: "Photo Parsing Ended: \(Date()), Parsing Time: \(elapsed) seconds")
        onSuccess(true)
    }
    
    
    
   
    
    
    
    
    
    
}
