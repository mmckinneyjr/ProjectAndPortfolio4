//
//  FoodMenuCell.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/15/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import UIKit

class FoodMenuCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}
