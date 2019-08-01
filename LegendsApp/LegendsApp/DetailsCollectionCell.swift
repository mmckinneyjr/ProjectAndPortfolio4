//  DetailsCollectionCell.swift
//  LegendsApp
//  Created by Mark Mckinney Jr. July 2019.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.

import UIKit

class DetailsCollectionCell: UICollectionViewCell {
   
    let globalFunc = GlobalFunctions()
    @IBOutlet weak var cellImage: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        globalFunc.ImageBorder(cellImage)
    }
}
