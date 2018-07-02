//
//  AppNetwork.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 23/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//


/////NOT USING FOR NOW
/*import Foundation
import Alamofire

class AppNetwork {
    static let shared: AppNetwork = AppNetwork()
    private init() {}
    private var reachabilityManager: NetworkReachabilityManager?
    
    //TODO: add appropriate logic under each 'reachability case'
    func startNetworkReachabilityObserver(host: String) {
        reachabilityManager = Alamofire.NetworkReachabilityManager(host: host)
        reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                Logger.log(message: "The network is not reachable", event: .info)
               // APPUtility.setUserDefaultsForBool(key: APPUSERDEFAULTS.NETWORK, bool: false)
              //  NotificationCenter.default.post(name: Notification.Name(NOTIFICATION.NETWORK), object: nil)
            case .unknown :
                Logger.log(message: "It is unknown whether the network is reachable", event: .info)
                //APPUtility.setUserDefaultsForBool(key: APPUSERDEFAULTS.NETWORK, bool: false)
               // NotificationCenter.default.post(name: Notification.Name(NOTIFICATION.NETWORK), object: nil)
            case .reachable(.ethernetOrWiFi):
               // APPUtility.setUserDefaultsForBool(key: APPUSERDEFAULTS.NETWORK, bool: true)
                Logger.log(message: "The network is reachable over the WiFi connection", event: .info)
            case .reachable(.wwan):
               // APPUtility.setUserDefaultsForBool(key: APPUSERDEFAULTS.NETWORK, bool: true)
                Logger.log(message: "The network is reachable over the WWAN connection", event: .info)
            }
        }
        reachabilityManager?.startListening()
    }
    
    func stopNetworkReachabilityObserver() {
        reachabilityManager?.stopListening()
    }
    
}*/
