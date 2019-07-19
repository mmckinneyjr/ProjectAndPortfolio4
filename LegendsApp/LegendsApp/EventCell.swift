//
//  EventCell.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/12/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)




    }

    @IBOutlet weak var attendingCollection: UICollectionView!
    @IBOutlet weak var cellBG: UIImageView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var attendingCount = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendingCount
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = attendingCollection.dequeueReusableCell(withReuseIdentifier: "collectionView_ID", for: indexPath) as! AttendingCell
        
        cell.attendingImage.image = UIImage(named: "attendingPlaceHolder")
        return cell

    }

    
    
}
