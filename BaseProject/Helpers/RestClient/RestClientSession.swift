//
//  RestClientSession.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 22/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import Alamofire

class RestClientSession {
    public var manager: SessionManager
    public static let `default`: RestClientSession = RestClientSession()
    public static let ephemeral: RestClientSession = RestClientSession(config: URLSessionConfiguration.ephemeral)
    
    private init() {
        let configuration = URLSessionConfiguration.default
        var timeOut: Double = 60.0
        if let time = UserDefaults.standard.object(forKey: "app.app.http.timeout") as? String {
            timeOut = Double(time) ?? timeOut
        }
        configuration.timeoutIntervalForRequest = Double(timeOut)
        manager = Alamofire.SessionManager(configuration: configuration)
        manager.session.configuration.requestCachePolicy = .useProtocolCachePolicy
    }
    private init(config: URLSessionConfiguration) {
        let configuration = config
        var timeOut: Double = 60.0
        if let time = UserDefaults.standard.object(forKey: "app.app.http.timeout") as? String {
            timeOut = Double(time) ?? timeOut
        }
        configuration.timeoutIntervalForRequest = Double(timeOut)
        manager = Alamofire.SessionManager(configuration: configuration)
    }
}
