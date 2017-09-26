//
//  FoodBankTebelCell.swift
//  FoodForAll
//
//  Created by amit on 4/25/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class FoodBankTebelCell: UITableViewCell {

    @IBOutlet weak var datelabel: UILabel!
    
    @IBOutlet weak var foodbankImage: UIImageView!
    
    @IBOutlet weak var foodbankName: UILabel!
    
    @IBOutlet weak var foodBankUserName: UILabel!
    
    @IBOutlet weak var foodbankCity: UILabel!
    
    @IBOutlet weak var foodbankDistance: UILabel!
    
    @IBOutlet weak var subCategeory: UILabel!
    
    @IBOutlet weak var categeory: UILabel!
    @IBOutlet weak var Quantity: UILabel!
    
    @IBOutlet weak var SubCategeoryImage: UIImageView!
    @IBOutlet weak var CategeoryImage: UIImageView!
    @IBOutlet weak var ShareButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
