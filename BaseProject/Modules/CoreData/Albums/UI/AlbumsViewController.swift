//
//  AlbumsViewController.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {
    var viewModel: AlbumViewModel?
    var userId: Int64?
    var userName: String?
    var userData: UserModel?
    @IBOutlet weak var albumTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
   viewModel = AlbumViewModel()
        // Do any additional setup after loading the view.
        
        self.setTableview()
        
        self.callAlbumData()
        
        self.title = "\(String(describing: userData?.name ?? "")) Album's"
        
    }
    
    func setUser(user: UserModel?) {
        userData = user
    }
    
    func callAlbumData() {
        if let model = viewModel {
            
            model.getDBAlbumData(forUser: userData?.id, searchText: "")
        }
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

extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableview() {
        self.albumTableView.tableFooterView = UIView()
        self.albumTableView.delegate = self
        self.albumTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(viewModel?.albumArray?.count ?? 0)
        return viewModel?.albumArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.AlbumTableViewCellIdentifier, for: indexPath) as UITableViewCell
        if let cellIs = cell as? AlbumTableViewCell {
            cellIs.selectionStyle = .none
            cellIs.setData(album: viewModel?.albumArray![indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController {
            controller.getPhotoForAlbum(album: viewModel?.albumArray![indexPath.row])
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    
    
    
    
}
