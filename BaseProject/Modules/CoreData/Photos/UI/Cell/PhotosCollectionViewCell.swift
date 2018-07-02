//
//  PhotosCollectionViewCell.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoName: UILabel!
    
    
    
    func setData(data: DBPhoto?) {
        
        photoName.text = data?.title ?? ""
        
        let imgURL = URL(string: data?.thumbnailUrl ?? "")
        
        photoImage.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "dangerIcon"))
        
        
        photoImage.setupForImageViewer()

        
        
    }
}
