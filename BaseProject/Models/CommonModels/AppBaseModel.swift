//
//  AppBaseModel.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AppModelError {
    var errorCode: String?
    var errorMessage: String?
}

struct AppModelMessage {
    var displayMessage: String?
    var serviceMessageList: Array<Any>?
    var messageLevel: String?
}


class AppBaseModel {
    
    var isSuccess: Bool?
    var status: String?
    var duration: Double?
    var host: String?
    var expires: Int16?
    var error: AppModelError?
    var message: AppModelMessage?
    
    init(with response: JSON) {
        
        self.isSuccess = response["success"].boolValue
        self.status = response["status"].stringValue
        self.duration = response["duration"].doubleValue
        self.host = response["host"].stringValue
        self.expires = response["expires"].int16
        
        let errorResponse = response["error"]
        if !errorResponse.isEmpty {
            self.error = AppModelError()
            self.error?.errorCode = errorResponse["errorCode"].stringValue
            self.error?.errorMessage = errorResponse["errorMessage"].stringValue
        }
        
        let messageResponse = response["message"]
        if !messageResponse.isEmpty {
            self.message = AppModelMessage()
            self.message?.displayMessage = messageResponse["displayMessage"].stringValue
            self.message?.messageLevel = messageResponse["messageLevel"].stringValue
            self.message?.serviceMessageList = messageResponse["serviceMessageList"].arrayValue
        }
    }
    
    init() {
    }
}
