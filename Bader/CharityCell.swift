//
//  CharityCell.swift
//  Bader
//
//  Created by AMJAD - on 14 رجب، 1440 هـ.
//  Copyright © 1440 هـ aa. All rights reserved.
//

import UIKit

class CharityCell: UITableViewCell {
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var city: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
