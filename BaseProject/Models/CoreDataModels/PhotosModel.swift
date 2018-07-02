//
//  PhotosModel.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import SwiftyJSON

class PhotosData: AppBaseModel {
    
    var photosArray: [PhotosModel]?
    
    override init() {
        super.init()
    }
    
    init?(_ response: JSON) {
        if response.isEmpty {
            return nil
        }
        super.init(with: response)
        
        if response.exists() {
            self.parseResponse(with: response)
        }    }
    
    private func parseResponse(with response: JSON) {
        for photo in response.arrayValue {
            if let photoModel = self.createPhotoModel(with: photo) {
                if self.photosArray == nil {
                    self.photosArray = [PhotosModel]()
                }
                self.photosArray?.append(photoModel)
            }
        }
    }
    
    private func createPhotoModel(with jsonObject: JSON) -> PhotosModel? {
        if jsonObject.isEmpty {
            return nil
        } else {
            return PhotosModel.init(jsonObject)
        }
    }
    
    
}


class PhotosModel: AppBaseModel {
    
    var id: Int64?
    var albumId: Int64?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    
    
    override init() {
        super.init()
    }
    
    init?(_ response: JSON) {
        if response.isEmpty {
            return nil
        }
        super.init(with: response)
        
        if response.exists() {
            self.parseResponse(with: response)
        }    }
    
    private func parseResponse(with response: JSON) {
        self.id = response["id"].int64
        self.albumId = response["albumId"].int64
        self.title = response["title"].stringValue
        self.url = response["url"].stringValue
        self.thumbnailUrl = response["thumbnailUrl"].stringValue
    }
    
}
