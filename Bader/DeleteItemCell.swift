//
//  DeleteItemCell.swift
//  Bader
//
//  Created by AMJAD - on 27 جما٢، 1440 هـ.
//  Copyright © 1440 هـ aa. All rights reserved.
//

import UIKit

class DeleteItemCell: UITableViewCell {

    
    @IBOutlet weak var Donation: UILabel!
    @IBOutlet weak var PersonName: UILabel!
    @IBOutlet weak var DeleteButton: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
