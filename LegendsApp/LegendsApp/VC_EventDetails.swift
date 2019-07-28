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
        
        UINavigationBar.appearance().titleTextAttributes = globalFunc.navTitle

        BGImage.image = detailsBGImage        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = BGImage.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.autoresizesSubviews = true
        BGImage.addSubview(blurView)
        loadAttending()
    }
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

        }
    }
    
    
    
    
    
    
    
    
    //UI Elements
    @IBOutlet weak var BGImage: UIImageView!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    
    
    
    @IBAction func attendingButton(_ sender: Any) {
        
        if attending == true {
            let attendingRef = db.collection("Events").document(eventTitle)
            attendingRef.updateData([
                "attending": FieldValue.arrayRemove([user!])
                ])
            
            attending = false
        }
            
        else if attending == false {
            let attendingRef = db.collection("Events").document(eventTitle)
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: "detailsCollectionCell", for: indexPath) as! DetailsCollectionCell
        

        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        // Reference to an image file in Firebase Storage
        let reference = storageRef.child("UserProfileImages/\(attendingUID[indexPath.row])")
                // Placeholder image
                let placeholderImage = UIImage(named: "attendingPlaceHolder")
                // Load the image using SDWebImage
        
                cell.cellImage.sd_setImage(with: reference, placeholderImage: placeholderImage)
                globalFunc.roundImage3(cell.cellImage!)

//        let islandRef = storageRef.child("UserProfileImages/\(attendingUID[indexPath.row])")
//
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        islandRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//            if let error = error {
//                print("error loading attending: \(error)")
//            } else {
//                // Data for "images/island.jpg" is returned
//                cell.cellImage.image = UIImage(data: data!)
//                self.globalFunc.roundImage3(cell.cellImage)
//
//            }
//        }
        
        
        
        
        
        
        
        
        
        
        
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
