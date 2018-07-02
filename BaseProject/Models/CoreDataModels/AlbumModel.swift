//
//  AlbumModel.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import SwiftyJSON

class AlbumData: AppBaseModel {
    
    var albumArray: [AlbumModel]?
    
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
        for album in response.arrayValue {
            if let albumModel = self.createAlbumModel(with: album) {
                if self.albumArray == nil {
                    self.albumArray = [AlbumModel]()
                }
                self.albumArray?.append(albumModel)
            }
        }
    }
    
    private func createAlbumModel(with jsonObject: JSON) -> AlbumModel? {
        if jsonObject.isEmpty {
            return nil
        } else {
            return AlbumModel.init(jsonObject)
        }
    }
    
    
}


class AlbumModel: AppBaseModel {
    
    var id: Int64?
    var userId: Int64?
    var title: String?
  
    
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
        self.userId = response["userId"].int64
        self.title = response["title"].stringValue
    }
    
}
