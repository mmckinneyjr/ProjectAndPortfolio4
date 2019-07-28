//
//  EventCell.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/12/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class EventCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    let globalFunc = GlobalFunctions()
    var attendingCount = 0
    var attendingingUIDs = [String]()
    var eventID = ""
    let db = Firestore.firestore()

    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendingCount
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = attendingCollection.dequeueReusableCell(withReuseIdentifier: "collectionView_ID", for: indexPath) as! AttendingCell

        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        // Reference to an image file in Firebase Storage
        let reference = storageRef.child("UserProfileImages/\(attendingingUIDs[indexPath.row])")
        // Placeholder image
        let placeholderImage = UIImage(named: "attendingPlaceHolder")
        // Load the image using SDWebImage
        cell.attendingImage.sd_setImage(with: reference, placeholderImage: placeholderImage)
        globalFunc.roundImage3(cell.attendingImage!)
        
        return cell
    }

    
    
    
    
    
    func loadAttending(){
        self.db.collection("Events").document(eventID)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.get("attending") as? [String] else {

                    self.attendingCollection.reloadData()

                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
        }
   }
    
    
    
    
    
    
    
}
