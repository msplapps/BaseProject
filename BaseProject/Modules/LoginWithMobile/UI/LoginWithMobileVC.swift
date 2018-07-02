//
//  LoginWithMobileVC.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 20/03/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import UIKit
import AccountKit

class LoginWithMobileVC: UIViewController {
    
    @IBOutlet weak var phoneText: UITextField!
    var accountKit: AKFAccountKit!
    var viewController: AKFViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        if accountKit == nil {
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        let trimmed = phoneText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        let phoneNumber = AKFPhoneNumber.init(countryCode: "91", phoneNumber: trimmed ?? "")
        let inputState = "3B918B64-6F17-4FC3-9569-6BF0985DA96E"
        print(inputState)
       /// 3B918B64-6F17-4FC3-9569-6BF0985DA96E
        viewController = accountKit!.viewControllerForPhoneLogin(with: phoneNumber, state: inputState)
        viewController?.enableSendToFacebook = true
        if let controller = viewController as? UIViewController {
            viewController?.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if accountKit.currentAccessToken != nil {
            print("User already logged in go to ViewController")
            DispatchQueue.main.async(execute: {
                print("Logged In")
            })
        }
    }
}

extension LoginWithMobileVC: AKFViewControllerDelegate {
    
    private func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print("Login succcess with AccessToken")
    }
    private func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("Login succcess with AuthorizationCode")
    }
    private func viewController(_ viewController: UIViewController!, didFailWithError error: NSError!) {
        print("We have an error \(error)")
    }
    private func viewControllerDidCancel(_ viewController: UIViewController!) {
        print("The user cancel the login")
    }
}
