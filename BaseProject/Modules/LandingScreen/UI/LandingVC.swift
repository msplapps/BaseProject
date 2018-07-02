//
//  LandingVC.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 27/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import UIKit
import CoreLocation
import Crashlytics

class LandingVC: AppBaseVC {
    
    
    
    var netWorkBackground: UIColor?
    @IBOutlet weak var landingTableViewController: UITableView!
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var viewModel: LandingModel?
    
    var dataArray = ["Check Network",
                     "Get Sample JSON Data",
                     "Crash the App",
                     "",
                     "Custom Font",
                     "Get User Location",
                     "Get Device Info",
                     "CoreData Example",
                     "Native Call Analyzer",
                     "Example for Time Ago",
                     "Login with PhoneNumber"]
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LandingModel()
        
        netWorkBackground = UIColor.white
        
        // Do any additional setup after loading the view.
        
        
        self.title = "Select Below Items"
        ///// Accessing UserLocation
        self.startListiningLocaton()
        
        self.setTableview()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LandingVC: UITableViewDelegate, UITableViewDataSource {
    
    func setTableview() {
        self.landingTableViewController.tableFooterView = UIView()
        self.landingTableViewController.delegate = self
        self.landingTableViewController.dataSource = self
        landingTableViewController.rowHeight = UITableViewAutomaticDimension
        landingTableViewController.estimatedRowHeight = 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dataArray.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 30
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Type in below keyboard"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.LandingIdentifier, for: indexPath) as UITableViewCell
            cell.selectionStyle = .none
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            
            cell.textLabel?.text = dataArray[indexPath.row]
            cell.contentView.backgroundColor = UIColor.white
            switch indexPath.row {
            case 0:
                cell.contentView.backgroundColor = netWorkBackground
            case 3:
                let imgURL = URL(string: "http://www.personal.psu.edu/oeo5025/jpg.jpg")
                cell.imageView?.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "dangerIcon"))
                cell.imageView?.frame = CGRect(x: (UIScreen.main.bounds.width - 100) / 2, y: 0, width: 100, height: 100)
            case 4:
                cell.textLabel?.setReguralFont(size: 22)
            case 9:
                let dateString = "2018-03-08 11:55:34"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: dateString)
                cell.detailTextLabel?.text = "\(timeAgoSince(date!))"
            default:
                break
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.LandingTableViewCellIdentifier, for: indexPath) as UITableViewCell
            if let cellIs = cell as? LandingTableViewCell {
                cellIs.selectionStyle = .none
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let rechable = (isReachable ?? false) ? "Reachable" : " Not Reachable"
                netWorkBackground = (isReachable ?? false) ? UIColor.appLightGreenColor : UIColor.appRedColor
                dataArray[0] = "Network: \(rechable)"
                self.landingTableViewController.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            case 1:
                self.getSampleData()
            case 2:
                Crashlytics.sharedInstance().crash()
            case 5:
                dataArray[5] = "Latitude: \(self.latitude), Longitude: \(self.longitude)"
                self.landingTableViewController.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
            case 6:
                dataArray[6] = "Device Info \nDevice Model: \(DeviceInfo.sharedStore.device.model)\nDevice Name: \(DeviceInfo.sharedStore.device.name)\nDevice System Version: \(DeviceInfo.sharedStore.device.systemVersion)\nDevice System Name: \(DeviceInfo.sharedStore.device.systemName)"
                self.landingTableViewController.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .automatic)
            case 7:
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController {
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            case 8:
                APPNativeCallAnalyzer.sharedInstance.openNativeCallAnalyzer(in: self, frame: self.view.frame)
            case 10:
                ///////////////
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginWithMobileVC") as? LoginWithMobileVC {
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            default:
                break
            }
        }
        //        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "AlbumsViewController") as? AlbumsViewController {
        //            controller.setUser(user: viewModel?.userDataModel?.usersArray![indexPath.row])
        //            self.navigationController?.pushViewController(controller, animated: true)
        //
        //        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 3 {
                return 100
            }
            return UITableViewAutomaticDimension
        default:
            return UITableViewAutomaticDimension
        }
    }
}

extension LandingVC {
    
    func getSampleData() {
        if let model = viewModel {
            let parms = ["key1": "value1",
                         "key2": "value2"]
            self.showHUD(title: "Getting Data")
            model.getSampleData(parameters: parms, onSuccess: { [weak self] (_) in
                print("Success")
                self?.dataArray[1] = "Get Sample JSON Data:  Successful"
                self?.landingTableViewController.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                self?.hideHud()
                }, onError: { (error) in
                    Logger.log(message: "Error \(error.statusMessage)", event: .error)
                    self.hideHud()
            })
        }
        
    }
}

extension LandingVC: LocationServiceDelegate {
    func startListiningLocaton() {
        LocationSingleton.sharedInstance.startUpdatingLocation()
        LocationSingleton.sharedInstance.delegate = self
    }
    
    func tracingLocation(currentLocation: CLLocation) {
        dprint(object: currentLocation.coordinate.latitude)
        dprint(object: currentLocation.coordinate.longitude)
        self.latitude = currentLocation.coordinate.latitude
        self.longitude = currentLocation.coordinate.longitude
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        dprint(object: error)
    }
}
