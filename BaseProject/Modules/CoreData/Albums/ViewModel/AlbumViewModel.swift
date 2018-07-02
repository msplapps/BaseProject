//
//  AlbumViewModel.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
class AlbumViewModel {
    
    
    
    var albumArray: [DBAlbum]?
    
    init() {
    }
    
    
    
    func getDBAlbumData(forUser: Int64?, searchText: String?) {
        if albumArray == nil {
            albumArray = []
        }
        albumArray =  APPDBUtility.getAlbumsData(userId: forUser, searchText: searchText, mocType: .main)
        print(albumArray?.count ?? 0)
        
    }
    
   
    
}
