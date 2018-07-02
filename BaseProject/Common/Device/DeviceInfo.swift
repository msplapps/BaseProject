//
//  DeviceInfo.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 27/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import DeviceKit

class DeviceInfo {
    static let sharedStore: DeviceInfo = DeviceInfo()
    private init() {
    }
    
    let device = Device()

}
