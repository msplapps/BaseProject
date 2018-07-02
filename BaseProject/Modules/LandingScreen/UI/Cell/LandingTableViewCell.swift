//
//  LandingTableViewCell.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 08/03/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import UIKit

class LandingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentText: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
