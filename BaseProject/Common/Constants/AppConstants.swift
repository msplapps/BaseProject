//
//  AppConstants.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 22/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation

// MARK: - Project Environment Type
struct Environment {
    static let Local: String = "Local"
    static let Production: String = "Production"
}

struct NetworkMessage {
    static let ErrorTitle: String = "No Network..!"
    static let ErrorMessage: String = "Please check your internet connection"
    
    static let SuccessTitle: String = "Connected to Network..!"
    static let SuccessMessage: String = "You have connected to active network"
}

// MARK: - App URL's
struct APPURL {
    static let SampleURL: String = "mralexgray/repos"
    static let NetworkURL: String = "www.apple.com"
    
    static let GetUsers: String = "users"
    static let GetAlbums: String = "albums"
    static let GetPhotos: String = "photos"

    
    static func getBaseURL() -> String {
        let env = APPStore.sharedStore.environment
        if env == Environment.Local {
            /// return "https://api.github.com/users/"
            return "https://jsonplaceholder.typicode.com/"
        } else if env == Environment.Production {
            // return "https://api.github.com/users/"
            return "https://jsonplaceholder.typicode.com/"
        } else {
            return "Empty URL"
        }
    }
}

// MARK: - All Tableview / Collectionview Identifiers will go here
struct CellIdentifiers {
    static let UserTableCellIdentifier: String = "UserTableCellIdentifier"
    static let AlbumTableViewCellIdentifier: String = "AlbumTableViewCellIdentifier"
    static let PhotosCollectionViewCellIdentifier: String = "PhotosCollectionViewCellIdentifier"
    static let LandingIdentifier: String = "LandingIdentifier"
    static let LandingTableViewCellIdentifier: String = "LandingTableViewCellIdentifier"

    
    
    
}

struct APPLoggerKey {
    static let restErrorCode: String = "qRestErrorCode"
    static let restErrorMsg: String = "qRestErrorMsg"
    static let restStatusCode: String = "qRestStatusCode"
    static let restStatusMsg: String = "qRestStatusMsg"
    static let restAPIName: String = "qRestAPIName"
    static let restExecTime: String = "qRestExecTime"
    static let httpError: String = "qHTTPError"
    static let restError: String = "qRestError"
}


// MARK: - Database

struct APPDBConstants {
    static let USER: String = "DBUser"
    static let ALBUM: String = "DBAlbum"
    static let PHOTO: String = "DBPhoto"
    
}

struct COREDATAErrorConstants {
    static let CoreDataErrorDomian: String = "CORE_DATA_ERROR_DOMAIN"
    static let CoreDataErrorCode: Int = 1001
}

struct ALERTMESSAGE {
    
    static let ALERT: String = "Alert..!"
    static let NOINTERNET: String = "Please check your internet connectivity..."
    
}

struct NOTIFICATION {
    static let NETWORK: String = "NETWORK"
    static let PhotosParsingDone: String = "PhotosParsingDone"
    
}


struct APPUSERDEFAULTS {
    
    static let NETWORK: String = "NETWORK"
    static let ParsingPhotos: String = "ParsingPhotos"

    
}
