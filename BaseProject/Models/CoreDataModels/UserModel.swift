//
//  UserModel.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserData: AppBaseModel {
    
    var usersArray: [UserModel]?
    
    override init() {
        super.init()
    }
    
    init?(_ response: JSON) {
        if response.isEmpty {
            return nil
        }
        super.init(with: response)
        
        if response.exists() {
            self.parseResponse(with: response)
        }    }
    
    private func parseResponse(with response: JSON) {
        for user in response.arrayValue {
            if let userModel = self.createUserModel(with: user) {
                if self.usersArray == nil {
                    self.usersArray = [UserModel]()
                }
                self.usersArray?.append(userModel)
            }
        }
    }
    
    private func createUserModel(with jsonObject: JSON) -> UserModel? {
        if jsonObject.isEmpty {
            return nil
        } else {
            return UserModel.init(jsonObject)
        }
    }
    
    
}


class UserModel: AppBaseModel {
    
    var id: Int64?
    var name: String?
    var username: String?
    var email: String?
    var address: UserAddressModel?
    var phone: String?
    var website: String?
    var company: UserCompanyModel?
    
    override init() {
        super.init()
    }
    
    init?(_ response: JSON) {
        if response.isEmpty {
            return nil
        }
        super.init(with: response)
        
        if response.exists() {
            self.parseResponse(with: response)
        }    }
    
    private func parseResponse(with response: JSON) {
        
        self.id = response["id"].int64
        self.name = response["name"].stringValue
        self.username = response["username"].stringValue
        self.email = response["email"].stringValue
        self.address = UserAddressModel.init(response["address"])
        self.phone = response["phone"].stringValue
        self.website = response["website"].stringValue
        self.company = UserCompanyModel.init(response["company"])
    }

}


class UserAddressModel: AppBaseModel {
    
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: UserGeoModel?
    
    override init() {
        super.init()
    }
    
    init?(_ response: JSON) {
        if response.isEmpty {
            return nil
        }
        super.init(with: response)
        
        if response.exists() {
            self.parseResponse(with: response)
        }    }
    
    private func parseResponse(with response: JSON) {
        self.street = response["street"].stringValue
        self.suite = response["suite"].stringValue
        self.city = response["city"].stringValue
        self.zipcode = response["zipcode"].stringValue
        self.geo = UserGeoModel.init(response["geo"])
    }
    
}

class UserGeoModel: AppBaseModel {
    
    var lat: Double?
    var lng: Double?
    
    override init() {
        super.init()
    }
    
    init?(_ response: JSON) {
        if response.isEmpty {
            return nil
        }
        super.init(with: response)
        
        if response.exists() {
            self.parseResponse(with: response)
        }    }
    
    private func parseResponse(with response: JSON) {
        self.lat = response["lat"].doubleValue
        self.lng = response["lng"].doubleValue
    }
    
}

class UserCompanyModel: AppBaseModel {
    
    var name: String?
    var suicatchPhrasete: String?
    var bs: String?
    
    
    override init() {
        super.init()
    }
    
    init?(_ response: JSON) {
        if response.isEmpty {
            return nil
        }
        super.init(with: response)
        
        if response.exists() {
            self.parseResponse(with: response)
        }    }
    
    private func parseResponse(with response: JSON) {
        self.name = response["name"].stringValue
        self.suicatchPhrasete = response["suicatchPhrasete"].stringValue
        self.bs = response["bs"].stringValue
    }
    
}
