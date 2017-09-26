//
//  ChatTVCell.swift
//  FoodForAll
//
//  Created by amit on 5/3/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class ChatTVCell: UITableViewCell {

    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var Datetime: UILabel!
    
    @IBOutlet weak var module: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
