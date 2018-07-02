//
//  RestError.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 22/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation

class RestError {
    let statusCode: Int
    let statusMessage: String
    init(_ code: Int, _ msg: String) {
        self.statusCode = code
        self.statusMessage = msg
    }
}
