//
//  AppUtility.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 23/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation


struct APPUtility {
    
    static public func setUserDefaultsForBool(key: String?, bool: Bool?) {
        let defaults = UserDefaults.standard
        defaults.set(bool, forKey: key ?? "")
    }
    
    static public func getUserDefaultsForBool(key: String?) -> Bool? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key ?? "") as? Bool
    }
    
    static public func setUserDefaultsForKey(key: String?, value: Any?) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key ?? "")
    }
    
    static public func getUserDefaultsForKey(key: String?) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key ?? "")
    }
    
}
