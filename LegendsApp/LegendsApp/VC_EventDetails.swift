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
import FirebaseUI

class VC_EventDetails: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    let user = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let globalFunc = GlobalFunctions()
    
    var attendingUID = [String]()
    var detailsBGImage = UIImage()
    var detailsDate = ""
    var detailsTitle = ""
    var detailsDetails = ""
    var detailsMoreDetails = ""
    var eventTitle = ""
    var attending: Bool? = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BGImage.image = detailsBGImage        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = BGImage.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.autoresizesSubviews = true
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
                    
                    if self.user != nil {
                    if self.attendingUID.contains(self.user!) {
                        self.attending = true
                    }
                    }
                    else { self.attending = false }
                    self.detailsCollectionView.reloadData()

                    print("Current data: \(data)")
        }
    }
    
    
    
    
    
    
    
    
    //UI Elements
    @IBOutlet weak var BGImage: UIImageView!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    
    
    
    @IBAction func attendingButton(_ sender: Any) {
        
        if attending == true {
            let attendingRef = db.collection("Events").document(eventTitle)
            // Atomically add a new region to the "regions" array field.
            attendingRef.updateData([
                "attending": FieldValue.arrayRemove([user!])
                ])
            
            attending = false
        }
            
        else if attending == false {
            let attendingRef = db.collection("Events").document(eventTitle)
            // Atomically add a new region to the "regions" array field.
            attendingRef.updateData([
                "attending": FieldValue.arrayUnion([user!])
                ])
            
            attending = true
        }
    }
    
    
    //Back Button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return attendingUID.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: "detailsCollectionCell", for: indexPath) as! DetailsCollectionCell
        

        let storage = Storage.storage()
        let storageRef = storage.reference()
        let reference = storageRef.child("UserProfileImages/\(attendingUID[indexPath.row])")
        let placeholderImage = UIImage(named: "attendingPlaceHolder")

        cell.cellImage.sd_setImage(with: reference, placeholderImage: placeholderImage)
        globalFunc.roundImage2(cell.cellImage)

        
        return cell
    }
    
    //Top View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let topDetails = detailsCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "detailsCollectionTop", for: indexPath) as! DetailsCollectionTop

        if user == nil {
            topDetails.attendingView.isHidden = true
        }
        else if user != nil {
            topDetails.attendingView.isHidden = false
        }
        
        topDetails.detailsTitleLabel.text = detailsTitle
        topDetails.detailsDateLabel.text = detailsDate
        topDetails.detailsMoreDetails.text = detailsMoreDetails
        topDetails.detailsDetails.text = detailsDetails
        topDetails.attendingLabel.text = "Attending: \(attendingUID.count)"

        
        //Changes attending button visual from attending to empty(not attending)
        if attending == true {
            topDetails.attendingButton.setImage(UIImage(named: "yes2"), for: .normal)
        }
        else if attending == false {
            topDetails.attendingButton.setImage(UIImage(named: "yes"), for: .normal)
        }

        return topDetails
    }
    
    
    //this is for the size of items (user images)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var iconSize: CGFloat = 4
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad: iconSize = 6
        case .phone: iconSize = 4
        default: print("ahhhhh What kind of device is this?")
        }
        
        
        let width = collectionView.frame.width / iconSize
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
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }

    
        
        
}
