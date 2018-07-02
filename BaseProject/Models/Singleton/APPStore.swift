//
//  AppSingleton.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 22/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
class APPStore {
    static let sharedStore: APPStore = APPStore()
    private init() {
    }
    
    var environment: String = Environment.Local


}
