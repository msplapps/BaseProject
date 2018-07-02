//
//  AppBaseVC.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 23/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import NotificationBannerSwift
import SDWebImage
import CoreLocation
import Crashlytics



class AppBaseVC: UIViewController {
    var loadingHud: MBProgressHUD?
    var isReachable: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.networkBanner()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - Adding MBPogress HUD
extension AppBaseVC {
    func showHUD(title: String?) {
        resetLoadingView()
        loadingHud = MBProgressHUD.showAdded(to: view, animated: true)
        loadingHud?.mode = MBProgressHUDMode.indeterminate
        loadingHud?.label.text = title
    }
    private func resetLoadingView() {
        if loadingHud == nil {
            loadingHud = MBProgressHUD()
        }
        loadingHud?.hide(animated: true)
    }
    func hideHud() {
        self.resetLoadingView()
    }
}
// MARK: - Adding a Network Banner
extension AppBaseVC {
    func networkBanner() {
        networkObserver { (reachable) in
            self.view.backgroundColor = reachable == true ? UIColor.appLightGreenColor : UIColor.appRedColor
            self.isReachable = reachable
            if self.isReachable ?? false {
//                let banner = NotificationBanner(title: NetworkMessage.SuccessTitle, subtitle: NetworkMessage.SuccessMessage, style: .success)
//                banner.duration = 1.0
//                banner.show()
            } else {
                let rightView = UIImageView(image: #imageLiteral(resourceName: "dangerIcon"))
                let banner = NotificationBanner(title: NetworkMessage.ErrorTitle, subtitle: NetworkMessage.ErrorMessage, rightView: rightView, style: .danger)
                banner.duration = 1.0
                /// banner.autoDismiss = false
                /// banner.dismissOnTap = true
                banner.show()
            }
        }
    }
    
    func networkObserver(networkReachable: @escaping (_ YES: Bool)->Void) {
        let net = NetworkReachabilityManager()
        net?.startListening()
        net?.listener = { status in
            print("\(status)")
            if net?.isReachable ?? false {
                networkReachable(true)
            } else {
                networkReachable(false)
            }
        }
    }
}
