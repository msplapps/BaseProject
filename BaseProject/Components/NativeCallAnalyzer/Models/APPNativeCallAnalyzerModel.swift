//
//  AppNativeCallAnalyzer.swift
//  NativeCallAnalyzer
//
//  Created by Santhosh Marripelli on 27/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation

public class APPNativeCallAnalyzerModel {
    var url: String
    var requestParameter: [String: Any]
    var requestHeaderParameter: [String: Any]
    var startDate: Date
    
    var callTime: String?
    var requestSize: String?
    var responseSize: String?
    var responseString: String?
    var statusDescription: String?
    var responseStatus: String?
    var errorDescription: String?
    var isExpanded: Bool = false
    
    public init(url: String, requestParameter: [String: Any]?,
                requestHeaderParameter: [String: Any], startDate: Date = Date()) {
        self.url = url
        self.requestParameter = requestParameter ?? [:]
        self.requestHeaderParameter = requestHeaderParameter
        self.startDate = startDate
    }
    
    public func endAnalyzerWith(task: URLSessionTask, responseString: String?, callTime: String, error: Error?) {
        self.responseString = responseString
        self.statusDescription = task.response?.description
        self.requestSize = String(task.countOfBytesSent)
        self.responseSize = String(task.countOfBytesReceived)
        self.errorDescription = error?.localizedDescription
        
        if let status = (task.response as? HTTPURLResponse)?.statusCode {
            self.responseStatus = "\(status)"
        }
        self.callTime = callTime
    }
    //swiftlint:disable function_parameter_count
    public func endAnalyzerWith(statusDescription: String,
                                countOfBytesSent: String, countOfBytesReceived: String,
                                responseString: String?, callTime: String, statusCode: Int) {
        self.responseString = responseString
        self.statusDescription = statusDescription
        self.requestSize = countOfBytesSent
        self.responseSize = countOfBytesReceived
        
        self.responseStatus = String(describing: statusCode)
        self.callTime = callTime
    }
    //swiftlint:enable function_parameter_count
}
