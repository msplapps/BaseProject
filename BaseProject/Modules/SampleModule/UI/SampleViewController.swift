//
//  SampleViewController.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 23/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import UIKit
import CoreLocation
import Crashlytics


class SampleViewController: AppBaseVC {
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var networkRechability: UILabel!
    var viewModel: SampleViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SampleViewModel()
        
          networkRechability.setReguralFont(size: 30)
        
        ////// Loading Image using SWWEB Image
        let imgURL = URL(string: "https://media.alienwarearena.com/media/1327-a.jpg")
        appImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "dangerIcon"))
        
       ///// Accessing UserLocation
       self.startListiningLocaton()
        
        
        ////////Accessing Device Info
        
        dprint(object: DeviceInfo.sharedStore.device.model)
        dprint(object: DeviceInfo.sharedStore.device.name)
        
        
//        //////////////CRASH BUTTON
//        let button = UIButton(type: .roundedRect)
//        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
//        button.setTitle("Crash", for: [])
//        button.addTarget(self, action: #selector(crashAppClicked), for: .touchUpInside)
//        self.view.addSubview(button)

        
        

    }
    
 
    @IBAction func crashAppClicked(_ sender: Any) {
        Crashlytics.sharedInstance().crash()
    }
    @IBAction func checkNetwork(_ sender: Any) {
        if self.isReachable! {
            networkRechability.text =  "Recahable"
        } else {
            networkRechability.text =  "Not Recahable"
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getSampleDataClicked(_ sender: Any) {
        if let model = viewModel {
            let parms = ["key1": "value1",
                         "key2": "value2"]
            self.showHUD(title: "Getting Data")
            model.getSampleData(parameters: nil, onSuccess: { [weak self] (_) in
                print("Success")
                self?.hideHud()

                }, onError: { (error) in
                    Logger.log(message: "Error \(error.statusMessage)", event: .error)
                    self.hideHud()

            })
        }
  
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
 
    
}

extension SampleViewController: LocationServiceDelegate {
    
    func startListiningLocaton() {
        LocationSingleton.sharedInstance.startUpdatingLocation()
        LocationSingleton.sharedInstance.delegate = self
    }
    
    func tracingLocation(currentLocation: CLLocation) {
        dprint(object: currentLocation.coordinate.latitude)
        dprint(object: currentLocation.coordinate.longitude)
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        dprint(object: error)
    }
}
