//
//  PhotosViewController.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    var viewModel: PhotosViewModel?
    var albumData: DBAlbum?
    var activityIndicator: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = PhotosViewModel()
        // Do any additional setup after loading the view.
        self.setCollectionView()
        self.getPhotos()
        self.addActivityIndicatior()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: UIBarMetrics.default)
        self.addTitleLabel()
        self.addNotifications()
    }
    
    
   
    
    func addTitleLabel() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        titleLabel.text = albumData?.title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
    }
    
    func addActivityIndicatior() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator?.hidesWhenStopped = true
        if APPUtility.getUserDefaultsForBool(key: APPUSERDEFAULTS.ParsingPhotos)! {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator!)
    }
    
    func getPhotos() {
        if let model = viewModel {
            model.getDBPhotoDataData(albumId: albumData?.id, searchText: "")
        }
    }
    
    func getPhotoForAlbum(album: DBAlbum?) {
        albumData = album
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

extension PhotosViewController {
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(parsingDone),
                                               name: NSNotification.Name(rawValue: NOTIFICATION.PhotosParsingDone), object: nil)
    }
    
    @objc func parsingDone() {
      self.activityIndicator?.stopAnimating()
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func setCollectionView() {
        self.photosCollectionView.dataSource = self
        self.photosCollectionView.delegate = self
        
        if let flow = photosCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemSpacing: CGFloat = 3
            let itemsInOneLine: CGFloat = 3
            flow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsInOneLine - 1)
            flow.itemSize = CGSize(width: floor(width/itemsInOneLine), height: width/itemsInOneLine)
            flow.minimumInteritemSpacing = 3
            flow.minimumLineSpacing = 3
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photoArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 220.0, height: 398.0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.PhotosCollectionViewCellIdentifier, for: indexPath)
        cell.tag = indexPath.row
        if let cellIs = cell as? PhotosCollectionViewCell {
   
            cellIs.setData(data: viewModel?.photoArray![indexPath.row])
            
            cellIs.layer.borderColor = UIColor.gray.cgColor
            cellIs.layer.borderWidth = 1.0
            cellIs.layer.masksToBounds = true
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }
}
