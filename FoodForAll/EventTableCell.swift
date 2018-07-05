//
//  EventTableCell.swift
//  FoodForAll
//
//  Created by think360 on 05/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell {

    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var EventTitle: UILabel!
    @IBOutlet weak var EventUserName: UILabel!
    @IBOutlet weak var EventAddress: UILabel!
    @IBOutlet weak var EventDistance: UILabel!
    @IBOutlet weak var EventStartDate: UILabel!
    @IBOutlet weak var EventStartTime: UILabel!
    @IBOutlet weak var EventEndDate: UILabel!
    @IBOutlet weak var EventEndTime: UILabel!
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
