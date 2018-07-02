//
//  RestClient.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 22/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RestClient {
    //intialization
    private init() {
        //Restrict RestClient intialization
    }
    static let defaultRestSession: RestClientSession = RestClientSession.default
    static let ephemeralRestSession: RestClientSession = RestClientSession.ephemeral
    static var sessionManager: SessionManager?
    
    static var requestMap: [String: DataRequest] = [:]
    /**
     
     Construct the RestError object with error code and message
     
     - parameters:
     - code: status code of restAPI response
     - msg: restAPI response error message string
     */
    internal static func restError(_ code: Int, msg: String ) -> RestError {
        return RestError(code, msg)
    }
    /**
     
     Construct the RestAPI request
     
     - parameters:
     - api: APICallAttributes
     - parameter: API parameter
     - method: HTTPMethod (get, post)
     - returns: DataRequest
     */
    internal static func apiRequest(_ api: APICallAttributes,
                                    method: APIMethod,
                                    apiHeaders: APIHeaders) -> RestClientRequest {
        switch api.taskType {
        case .aunthentication:
            sessionManager = ephemeralRestSession.manager
            break
        case .dataTask:
            sessionManager = defaultRestSession.manager
            break
        }
        let url = APPURL.getBaseURL() + api.endPoint
        dprint(object: url)
        let clientRequest = RestClientRequest()
        switch method {
        case .post:
            clientRequest.dataRequest = sessionManager?.request(url, method: method,
                                                                parameters: api.parameter ?? [:],
                                                                encoding: JSONEncoding.default,
                                                                headers: apiHeaders)
            
        case .get:
            clientRequest.dataRequest = sessionManager?.request(url, method: method,
                                                                parameters: api.parameter ?? [:],
                                                                encoding: URLEncoding.queryString,
                                                                headers: apiHeaders)
        default:
            clientRequest.dataRequest = sessionManager?.request(url, method: method,
                                                                parameters: api.parameter ?? [:],
                                                                encoding: URLEncoding.default,
                                                                headers: apiHeaders)
        }
        return clientRequest
    }
    /**
     
     Construct the RestAPI Headers
     - returns: HTTPHeaders
     */
    internal static func apiHeaders() -> HTTPHeaders {
        let headers = [APIHeadersType.content: APIHeadersType.json]
        return headers
    }
    public static func dataRequestAPICall(apiEndUrl: String,
                                          parametes: APIParameter?,
                                          httpMethd: APIMethod,
                                          onSuccess: @escaping APISuccessHandler,
                                          onError: @escaping APIErrorHandler) {
        RestClient.dataRequestAPICall(
            (taskType: RestRequestTask.dataTask, endPoint: apiEndUrl, parameter: parametes, mimeType: nil),
            httpMethod: httpMethd,
            onSuccess: onSuccess,
            onError: onError)
    }

}

extension RestClient: RestClientProtocol {
    
    public static func cancelAllRequests() {
        sessionManager?.session.invalidateAndCancel()
    }
    //swiftlint:disable function_body_length
    public static func dataRequestAPICall(_ api: APICallAttributes, httpMethod: APIMethod,
                                          onSuccess: @escaping APISuccessHandler,
                                          onError: @escaping APIErrorHandler) {
        var headers = apiHeaders()
        if let mime = api.mimeType {
            headers[APIHeadersType.content] = mime
        }
        let startTime = Date()
        let clientRequest = apiRequest(api, method: httpMethod, apiHeaders: headers)
        guard let dataRequest = clientRequest.dataRequest else {
            let error = restError(RestClientErrorCodes.nullRequestObject, msg: RestClientErrorMessage.nullRequestObject)
            onError(error)
            return
        }
        dataRequest.validate()
        if let req = requestMap[api.endPoint] {
            req.cancel()
        }
        requestMap[api.endPoint] = dataRequest
        
        dataRequest.responseJSON { (dataResponse) in
            requestMap.removeValue(forKey: api.endPoint)
            
            guard let urlResponse = dataResponse.response else {
                RestClient.printRestAPIResponse(dataRequest, api: api, dataResponse: dataResponse, startDate: startTime)
                let responseError = urlResponseError(api.parameter, dataResponse.error, dataRequest)
                let execution = getExecuteTime(startTime, dataRequest)
                restCallLogging(execution.name, execution.time, "\(responseError.statusCode)", responseError.statusMessage, APPLoggerKey.restError)
                onError(responseError)
                return
            }
            dprint(object: dataResponse.result)

            switch dataResponse.result {
            case .success:
                RestClient.printRestAPIResponse(dataRequest, api: api, dataResponse: dataResponse, startDate: startTime)
                let execution = getExecuteTime(startTime, dataRequest)
                let jsonObject = JSON.init(dataResponse.result.value ?? "")
                let status = jsonObject["status"].string ?? ""
                Logger.log(message: status, event: .info)
                Logger.log(message: "Need to Parse Data Here for Project", event: .remember)
                Logger.log(message: "Response Parsing Time \(execution)", event: .info)
                onSuccess(jsonObject)
                
                //                if let json = dataResponse.result.value as? [String: Any] {
                //                    let execution = getExecuteTime(startTime, dataRequest)
                //                    let jsonObject = JSON.init(json)
                //                    let status = jsonObject["status"].string ?? ""
                //
                //                    Logger.log(message: "Need to Parse Data Here for Project", event: .remember)
                //
                //                } else {
                //                    Logger.log(message: "Need to Parse Data Here for Project", event: .remember)
                //                    let execution = getExecuteTime(startTime, dataRequest)
                //                    let statusCodeDescription = HTTPURLResponse.localizedString(forStatusCode: urlResponse.statusCode)
                //                    let restJSONError = restError(urlResponse.statusCode, msg: statusCodeDescription)
                //                    restCallLogging(execution.name, execution.time, "\(urlResponse.statusCode)", statusCodeDescription, APPLoggerKey.restError)
                //                    onError(restJSONError)
            //                }
            case .failure(let error):
                
                Logger.log(message: "Failure Case need to be handled here", event: .remember)
                
                let execution = getExecuteTime(startTime, dataRequest)
                RestClient.printRestAPIResponse(dataRequest, api: api, startDate: startTime, error: error)
                let responseError = restError(urlResponse.statusCode, msg: error.localizedDescription)
                restCallLogging(execution.name, execution.time, "\(urlResponse.statusCode)", error.localizedDescription, APPLoggerKey.httpError)
                onError(responseError)
            }
        }
    }
    
    
    private static func restCallLogging(_ call: String, _ time: String, _ code: String, _ message: String, _ type: String) {
        var logDict: [String: Any] = [APPLoggerKey.restAPIName: call,
                                      APPLoggerKey.restExecTime: time]
        if type == APPLoggerKey.httpError {
            logDict[APPLoggerKey.restErrorCode] = code
            logDict[APPLoggerKey.restErrorMsg] = message
        } else {
            logDict[APPLoggerKey.restStatusCode] = code
            logDict[APPLoggerKey.restStatusMsg] = message
        }
        ////Log File
       dprint(object: logDict)
    }

    
    private static func urlResponseError(_ params: APIParameter?, _ responseError: Error?, _ dataRequest: DataRequest) -> RestError {
        if let restUrlError = responseError as NSError? {
            return restError(restUrlError.code, msg: restUrlError.localizedDescription)
        } else {
            return restError(RestClientErrorCodes.nullResponseObject, msg: RestClientErrorMessage.nullResponseObject)
        }
    }
    
    private static func getExecuteTime(_ startTime: Date, _ dataRequest: DataRequest) -> (time: String, name: String) {
        let endTime = Date()
        let interval = endTime.timeIntervalSince(startTime)
        let executeTime = "\(Int(interval) * 1000 )"
        let urlString = dataRequest.request?.url?.absoluteString ?? ""
        let baseURLString = APPURL.getBaseURL()
        let api = urlString.getRestAPIName(baseURLString)
        return ("\(executeTime)", api)
    }
    
    static func printRestAPIResponse(_ dataRequest: DataRequest,
                                     api: APICallAttributes,
                                     dataResponse: DataResponse<Any>? = nil, startDate: Date,
                                     error: Error? = nil) {
        //Recording Service Call for Call Analyzer
        let urlString = "\(APPURL.getBaseURL())" + "\(api.endPoint)"
        let duration = Date().timeIntervalSince(startDate)
        let durationStr = String(format: "%.3f", duration)
        var parameters: [String: Any]? = nil
        if let validParameters = api.parameter {
            parameters = validParameters
            dprint(object: parameters)
        }
        
        ///// NativeCallAnalyzer Data
        let model = APPNativeCallAnalyzerModel(url: urlString,
                                               requestParameter: parameters,
                                               requestHeaderParameter: apiHeaders())
        
        
        var jsonResponse: [String: Any]? = nil
        if let json = dataResponse?.result.value as? [String: Any] {
            jsonResponse = json
            dprint(object: jsonResponse)
        } else {
            Logger.log(message: "Rest Service,  Invalid Response for \(api.endPoint):, error: \(error.debugDescription)", event: .error)
        }
        
        let reponseCode = dataResponse?.response?.statusCode ?? 0

        
        if let task = dataRequest.task {
            /*avoiding prints to native call analyzer for accessories response to avoid crashes in 1 GB ipad mini(s)*/
            model.endAnalyzerWith(task: task, responseString: jsonResponse?.description ?? "\(String(describing: dataResponse))",
                    callTime: durationStr, error: dataResponse?.error)
        } else {
            model.endAnalyzerWith(statusDescription: HTTPURLResponse.localizedString(forStatusCode: reponseCode),
                                  countOfBytesSent: "0",
                                  countOfBytesReceived: "0",
                                  responseString: jsonResponse?.description, callTime: durationStr,
                                  statusCode: reponseCode)
        }
        APPNativeCallAnalyzer.sharedInstance.addNetworkCallLog(callInfo: model)
        Logger.log(message: "Rest Service \(api.endPoint) is stored in call analyzer", event: .info)
        Logger.log(message: "Call Duration: \(durationStr)", event: .info)
    }
    
}
