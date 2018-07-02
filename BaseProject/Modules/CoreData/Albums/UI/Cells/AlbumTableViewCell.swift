//
//  AlbumTableViewCell.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 26/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(album: DBAlbum?) {
        albumName.text = album?.title ?? ""
       
    }

}
