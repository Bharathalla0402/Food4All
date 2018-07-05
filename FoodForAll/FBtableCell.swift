//
//  FBtableCell.swift
//  FoodForAll
//
//  Created by amit on 5/4/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class FBtableCell: UITableViewCell {

    
    
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var foodBankName: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var foodBnkUserName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var sliderFdBnk: WOWMarkSlider!
    @IBOutlet weak var percentLbl: UILabel!
    @IBOutlet weak var Bottomlbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
