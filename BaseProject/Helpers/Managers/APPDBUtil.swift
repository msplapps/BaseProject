//
//  APPDBUtil.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 27/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
class APPDBUtil {

    class func updateLastUpdatedDateInUserDefaults(catalogType: CatalogDataUpdateType) {
        let date = Date()
        let dateInDouble = date.timeIntervalSince1970
        UserDefaults.standard.setValue(dateInDouble, forKey: catalogType.rawValue)
        UserDefaults.standard.synchronize()
    }
    

}
