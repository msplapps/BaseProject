//
//  AppDataManager.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 23/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation

class AppDataManager {
    
    class func getSampleData(parametes: [String: Any]?,
                                  onSuccess: @escaping (Bool?) -> Void,
                                  onFailure: @escaping APIErrorHandler) {
        
        RestClient.dataRequestAPICall(apiEndUrl: APPURL.GetUsers,
                                         parametes: parametes,
                                         httpMethd: APIMethod.get,
                                         onSuccess: { (apiResponse) in
                                            let userData = UserData.init(apiResponse)
                                            print(userData?.usersArray![2].username ?? "")
                                    onSuccess(true)
        },
                                         onError: { (error) in
                                            Logger.log(message: "Error: \(error.statusMessage) \(error.statusCode)", event: .error)
                                            onFailure(error)
        })
    }
    
    
    
    class func getUserData(parametes: [String: Any]?,
                           onSuccess: @escaping (UserData?) -> Void,
                             onFailure: @escaping APIErrorHandler) {
        
        RestClient.dataRequestAPICall(apiEndUrl: APPURL.GetUsers,
                                      parametes: parametes,
                                      httpMethd: APIMethod.get,
                                      onSuccess: { (apiResponse) in
                                        APPDBModel.saveUserInDB(apiResponse)
                                        let userData = UserData.init(apiResponse)
                                        print(userData?.usersArray![2].username ?? "")
                                        print(userData?.usersArray![2].address?.street ?? "")
                                        print(userData?.usersArray![2].address?.geo?.lat ?? "")
                                        print(userData?.usersArray![2].address?.geo?.lng ?? "")
                                        onSuccess(userData)
        },
                                      onError: { (error) in
                                        Logger.log(message: "Error: \(error.statusMessage) \(error.statusCode)", event: .error)
                                        onFailure(error)
        })
    }
    
    class func getAlbumData(parametes: [String: Any]?,
                           onSuccess: @escaping (AlbumData?) -> Void,
                           onFailure: @escaping APIErrorHandler) {
        
        RestClient.dataRequestAPICall(apiEndUrl: APPURL.GetAlbums,
                                      parametes: parametes,
                                      httpMethd: APIMethod.get,
                                      onSuccess: { (apiResponse) in
                                        APPDBModel.saveAlbumInDB(apiResponse)
                                        let albumData = AlbumData.init(apiResponse)
                                        print(albumData?.albumArray![2].title ?? "")
                                        print(albumData?.albumArray![2].userId ?? "")
                                        onSuccess(albumData)
        },
                                      onError: { (error) in
                                        Logger.log(message: "Error: \(error.statusMessage) \(error.statusCode)", event: .error)
                                        onFailure(error)
        })
    }
    
    class func getPhotoData(parametes: [String: Any]?,
                            onSuccess: @escaping (PhotosData?) -> Void,
                            onFailure: @escaping APIErrorHandler) {
        
        RestClient.dataRequestAPICall(apiEndUrl: APPURL.GetPhotos,
                                      parametes: parametes,
                                      httpMethd: APIMethod.get,
                                      onSuccess: { (apiResponse) in
                                        
                                        DispatchQueue.global().async {
                                            APPUtility.setUserDefaultsForBool(key: APPUSERDEFAULTS.ParsingPhotos, bool: true)
                                            APPDBModel.savePhotoInDB(apiResponse, mocType: .main, onSuccess: {(success) in
                                                print(success)
                                            })
                                            DispatchQueue.main.async {
                                                APPUtility.setUserDefaultsForBool(key: APPUSERDEFAULTS.ParsingPhotos, bool: false)
                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.PhotosParsingDone),
                                                                                object: nil)
                                            }
                                        }
                                        
                                        let photoData = PhotosData.init(apiResponse)
                                        print(photoData?.photosArray![2].title ?? "")
                                        print(photoData?.photosArray![2].thumbnailUrl ?? "")
                                        onSuccess(photoData)
        },
                                      onError: { (error) in
                                        Logger.log(message: "Error: \(error.statusMessage) \(error.statusCode)", event: .error)
                                        onFailure(error)
        })
    }
    
    
    
    
    
}
