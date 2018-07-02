//
//  RestClientConstants.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 22/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias APIMethod = HTTPMethod

typealias APIHeaders = [String: String]
typealias APIParameter = [String: Any]?
typealias APIResponse = JSON
typealias APISuccessHandler = (APIResponse) -> Void
typealias APIErrorHandler = (RestError) -> Void
typealias APICallAttributes = (taskType: RestRequestTask, endPoint: String, parameter: APIParameter?, mimeType: String?)

enum RestRequestTask: Int {
    case aunthentication, dataTask
    var type: Int {
        switch self {
        case .aunthentication:
            return RestClientTask.auth
        case .dataTask:
            return RestClientTask.data
        }
    }
}

enum RestClientConstants {
    static let reqTimeOutSec: TimeInterval = 30
}

enum RestClientTask {
    static let auth: Int = 1000
    static let data: Int = 2000
}
enum RestClientErrorCodes {
    static let emptyJSON: Int = 1000
    static let nullRequestObject: Int = 1001
    static let nullResponseObject: Int = 1002
}

enum RestClientErrorMessage {
    static let emptyJSON: String =  "EMPTY JSON RESPONSE"
    static let nullRequestObject: String = "Request object as null"
    static let nullResponseObject: String = "Response object as null"
}

enum APIHeadersType {
    static let accept: String = "accept"
    static let content: String = "Content-Type"
    static let json: String = "application/json"
}

enum MimeType {
    static let imagePng: String = "image/png"
}

enum URLs {
    static let baseURL: String = APPURL.getBaseURL()
    static let overViewURL: String = "quote/overview?mtn=7038501988"
}
