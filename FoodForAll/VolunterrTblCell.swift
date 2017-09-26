//
//  VolunterrTblCell.swift
//  FoodForAll
//
//  Created by amit on 4/25/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class VolunterrTblCell: UITableViewCell {
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userCountry: UILabel!
    @IBOutlet weak var facebookShare: UIButton!
    @IBOutlet weak var twitterShare: UIButton!
    @IBOutlet weak var GoogleShare: UIButton!
    @IBOutlet weak var userDescrription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
