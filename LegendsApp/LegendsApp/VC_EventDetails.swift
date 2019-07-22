//
//  VC_EventDetails.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/12/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import "UIImageView+FirebaseStorage.h"

class VC_EventDetails: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let uid = Auth.auth().currentUser?.uid
    var attendingUID = [String]()
    var detailsBGImage = UIImage()
    var detailsDate = ""
    var detailsTitle = ""
    var detailsDetails = ""
    var detailsMoreDetails = ""
    var eventTitle = ""
    let db = Firestore.firestore()
    var attending: Bool? = nil
    let storage = Storage.storage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BGImage.image = detailsBGImage
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = BGImage.bounds
        BGImage.addSubview(blurView)
        loadAttending()
        
    }
    
    
    
    
    func loadAttending(){

            self.db.collection("Events").document(self.eventTitle)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.get("attending") as? [String] else {
                        
                        self.detailsCollectionView.reloadData()

                        print("Document data was empty.")
                        return
                    }
                    self.attendingUID.removeAll()
                    self.attendingUID =  data
                    if self.attendingUID.contains(self.uid!) {  self.attending = true }
                    else { self.attending = false }
                    self.detailsCollectionView.reloadData()

                    print("Current data: \(data)")
          
        }
        
            for i in self.attendingUID {
                print("UID: \(i)")
            }
        
        
    }
    
    
    
    
    
    
    
    
    //UI Elements
    @IBOutlet weak var BGImage: UIImageView!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    
    
    
    @IBAction func attendingButton(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        
        
        
        if attending == true {
            let attendingRef = db.collection("Events").document(eventTitle)
            // Atomically add a new region to the "regions" array field.
            attendingRef.updateData([
                "attending": FieldValue.arrayRemove([uid!])
                ])
            
            attending = false
        }
            
        else if attending == false {
            let attendingRef = db.collection("Events").document(eventTitle)
            // Atomically add a new region to the "regions" array field.
            attendingRef.updateData([
                "attending": FieldValue.arrayUnion([uid!])
                ])
            
            attending = true
        }
        
        
        
        
        for i in self.attendingUID {
            print("UID: \(i)")
        }
        detailsCollectionView.reloadData()
    }
    
    
    //Back Button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return attendingUID.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        
        let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: "detailsCollectionCell", for: indexPath) as! DetailsCollectionCell
        
     
        let referenceImage: StorageReference = storageRef.child("test/.jpg")
        
        cell.cellImage.sd_setImage(with: "url", placeholderImage: #imageLiteral(resourceName: "placeholder"))

        
        return cell
    }
    
    //Top View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let topDetails = detailsCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "detailsCollectionTop", for: indexPath) as! DetailsCollectionTop
        
        topDetails.detailsTitleLabel.text = detailsTitle
        topDetails.detailsDateLabel.text = detailsDate
        topDetails.detailsMoreDetails.text = detailsMoreDetails
        topDetails.detailsDetails.text = detailsDetails
        
        //Changes attending button visual from attending to empty(not attending)
        if attending == true {
            topDetails.attendingButton.setImage(UIImage(named: "yes2"), for: .normal)
        }
        else if attending == false {
            topDetails.attendingButton.setImage(UIImage(named: "yes"), for: .normal)
            
        }
        
        let fixedWidth = topDetails.frame.size.width
        let newSize = topDetails.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        topDetails.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        let fixedWidth2 = topDetails.detailsDetails.frame.size.width
        let newSize2 = topDetails.detailsDetails.sizeThatFits(CGSize(width: fixedWidth2, height: CGFloat.greatestFiniteMagnitude))
        topDetails.detailsDetails.frame.size = CGSize(width: max(newSize2.width, fixedWidth2), height: newSize2.height)
        
        return topDetails
    }
    
    
    //this is for the size of items (user images)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/5
        return CGSize(width: width - 20, height: width - 20)
    }
    
    //these configure the spacing between items (user images)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    

        
        
}
