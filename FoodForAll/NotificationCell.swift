//
//  NotificationCell.swift
//  FoodForAll
//
//  Created by think360 on 04/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var fimage: UIImageView!
    @IBOutlet weak var CategeoryType: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var LocationAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
