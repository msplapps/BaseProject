//
//  DebugPrint.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 23/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation


func dprint(object: Any?, function: StaticString = #function, file: StaticString = #file, line: UInt = #line) {
        #if DEBUG
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy HH:mm:ss.SSS"
        let encodedFilePath = NSString(string: String(describing: file)).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!
        let fileName = NSURL(string: String(encodedFilePath))!.lastPathComponent!
        let debugStart = "///////////////////////////////////////////////   Debug Start   ///////////////////////////////////////////////"
            
            let debugEnd = "///////////////////////////////////////////////   Debug End   ///////////////////////////////////////////////"
            
        Swift.print("\(debugStart)\nDate: \(format.string(from: Date() as Date)) \nClass: \(fileName) \nLine: [\(line)] \nFunction: \(function) \nData: \(object ?? "nil") \n\(debugEnd)", terminator: "\n")
    #endif
}
