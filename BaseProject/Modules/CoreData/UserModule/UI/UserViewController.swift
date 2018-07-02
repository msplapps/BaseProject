//
//  ParsingViewController.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import UIKit

class UserViewController: AppBaseVC {
    var viewModel: UserViewModule?
    
    
    @IBOutlet weak var userTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = UserViewModule()
        // Do any additional setup after loading the view.
        
        self.setTableview()
        
        ////// GET USER DATA
        self.getUserData()
        self.getAlbumData()
        self.getPhotosData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableview() {
        self.userTableview.tableFooterView = UIView()
        
        self.userTableview.delegate = self
        self.userTableview.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.userDataModel?.usersArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.UserTableCellIdentifier, for: indexPath) as UITableViewCell
        if let cellIs = cell as? UserTableCell {
            cellIs.selectionStyle = .none
            cellIs.setData(user: viewModel?.userDataModel?.usersArray![indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "AlbumsViewController") as? AlbumsViewController {            
            controller.setUser(user: viewModel?.userDataModel?.usersArray![indexPath.row])
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    
    
    
    
}

// MARK: - Making Api Calls
extension UserViewController {
    func getUserData() {
        if let model = viewModel {
            self.showHUD(title: "Getting User Data")
            model.getUserData(parameters: nil, onSuccess: { [weak self] (_) in
                dprint(object: "Success")
                self?.hideHud()
                self?.userTableview.reloadData()
                }, onError: { (error) in
                    Logger.log(message: "Error \(error.statusMessage)", event: .error)
                    self.hideHud()
            })
        }
    }
    func getAlbumData() {
        if let model = viewModel {
            self.showHUD(title: "Getting Album Data")
            model.getAlbumData(parameters: nil, onSuccess: { [weak self] (_) in
                dprint(object: "Success")
                self?.hideHud()
                self?.userTableview.reloadData()
                }, onError: { (error) in
                    Logger.log(message: "Error \(error.statusMessage)", event: .error)
                    self.hideHud()
            })
        }
    }
    
    func getPhotosData() {
        if let model = viewModel {
            self.showHUD(title: "Getting Photo Data")
            model.getPhotoData(parameters: nil, onSuccess: { [weak self] (_) in
                dprint(object: "Success")
                self?.hideHud()
                self?.userTableview.reloadData()
                }, onError: { (error) in
                    Logger.log(message: "Error \(error.statusMessage)", event: .error)
                    self.hideHud()
            })
        }
    }
}
