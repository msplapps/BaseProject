//
//  LoggingModel.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 23/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation

// Enum for showing the type of Log Types
enum LogEvent: String {
    case error = "[‼️]" // error
    case info = "[ℹ️]" // info
    case debug = "[💬]" // debug
    case verbose = "[🔬]" // verbose
    case warning = "[⚠️]" // warning
    case severe = "[🔥]" // severe
    case remember = "[🔴]" // remember
}

class Logger {
    
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    class func log(message: String,
                   event: LogEvent,
                   fileName: String = #file,
                   line: Int = #line,
                   column: Int = #column,
                   funcName: String = #function) {
        
        #if DEBUG
            
            let loggerStart = "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  Logger Start  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
            
            let loggerEnd = "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  Logger End  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
            
            
            print("\(loggerStart)\n\(event.rawValue)\nDate: \(Date().toString())\nFilename:[\(sourceFileName(filePath: fileName))]:\nLine:\(line) \nColumn: \(column) \nFunction: \(funcName) -> \nMessage: \(message)\n\(loggerEnd)")
        #endif
    }
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
