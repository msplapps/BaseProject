//
//  RestClientProtocols.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 22/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import Alamofire

protocol  RestClientProtocol {
    //REST API call
    static func dataRequestAPICall(_ api: APICallAttributes,
                                   httpMethod: APIMethod,
                                   onSuccess: @escaping APISuccessHandler,
                                   onError: @escaping APIErrorHandler)
    //Cancel all requests
    static func cancelAllRequests()
}
