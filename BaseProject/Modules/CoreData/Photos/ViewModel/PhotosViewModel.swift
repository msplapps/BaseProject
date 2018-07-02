//
//  PhotosViewModel.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation

class PhotosViewModel {
    
    
    
    var photoArray: [DBPhoto]?
    
    init() {
    }
    
    
    
    func getDBPhotoDataData(albumId: Int64?, searchText: String?) {
        if photoArray == nil {
            photoArray = []
        }
        photoArray =  APPDBUtility.getPhotosData(albumId: albumId, searchText: "", mocType: .main)
        
        
    }
    
    
    
}
