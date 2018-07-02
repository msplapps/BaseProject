//
//  UserViewModule.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation

class UserViewModule {
    
    
    var userDataModel: UserData?
    var albumModel: AlbumData?
    var photoModel: PhotosData?
    
    init() {
    }
    
    
    func getUserData(parameters: [String: Any]?,
                     onSuccess: @escaping (Bool?) -> Void,
                     onError: @escaping APIErrorHandler) {
        AppDataManager.getUserData(parametes: parameters, onSuccess: { (dataSource) in
            self.userDataModel = dataSource
            dprint(object: dataSource)
            onSuccess(true)
            dprint(object: dataSource)
        }, onFailure: { (error) in
            onError(error)
            Logger.log(message: "Error: \(error.statusMessage) \(error.statusCode)", event: .error)
        })
    }
    
    
    func getAlbumData(parameters: [String: Any]?,
                     onSuccess: @escaping (Bool?) -> Void,
                     onError: @escaping APIErrorHandler) {
        AppDataManager.getAlbumData(parametes: parameters, onSuccess: { (dataSource) in
            self.albumModel = dataSource
            dprint(object: dataSource)
            onSuccess(true)
            dprint(object: dataSource)
        }, onFailure: { (error) in
            onError(error)
            Logger.log(message: "Error: \(error.statusMessage) \(error.statusCode)", event: .error)
        })
    }
    
    
    func getPhotoData(parameters: [String: Any]?,
                      onSuccess: @escaping (Bool?) -> Void,
                      onError: @escaping APIErrorHandler) {
        AppDataManager.getPhotoData(parametes: parameters, onSuccess: { (dataSource) in
            self.photoModel = dataSource
            dprint(object: dataSource)
            onSuccess(true)
            dprint(object: dataSource)
        }, onFailure: { (error) in
            onError(error)
            Logger.log(message: "Error: \(error.statusMessage) \(error.statusCode)", event: .error)
        })
    }
    
    
}
