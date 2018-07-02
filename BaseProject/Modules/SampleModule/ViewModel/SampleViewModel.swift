//
//  SampleViewModel.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 23/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation

class SampleViewModel {
    
    init() {
    }
    
    func getSampleData(parameters: [String: Any]?,
                       onSuccess: @escaping (Bool?) -> Void,
                       onError: @escaping APIErrorHandler) {
        AppDataManager.getSampleData(parametes: parameters, onSuccess: { (dataSource) in
            dprint(object: dataSource)
            onSuccess(dataSource)
            dprint(object: dataSource)
        }, onFailure: { (error) in
            onError(error)
            Logger.log(message: "Error: \(error.statusMessage) \(error.statusCode)", event: .error)
        })
    }
    
}
