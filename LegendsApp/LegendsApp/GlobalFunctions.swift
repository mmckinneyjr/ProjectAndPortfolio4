//
//  FontClass.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/12/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class GlobalFunctions {
    
    let user = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    let navTitle = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Prime", size: 20)!]
    
    
    func roundImage(_ image: UIImageView){
        image.layer.borderWidth = 2
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
    func roundImage2(_ image: UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.layer.borderColor = UIColor(red:225/255, green:107/255, blue:55/255, alpha: 1).cgColor
        image.contentMode = UIView.ContentMode.scaleToFill

    }
    
    func roundImage3(_ image: UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        image.layer.borderColor = UIColor(red:225/255, green:107/255, blue:55/255, alpha: 1).cgColor
    }
    
    func ImageBorder(_ image: UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func profileRoundImage(_ image: UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }

    func loadProfilePhoto(_ image: UIImageView){
        guard let UID = user else { return }
        
        let docRef = db.collection("Users").document(UID)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let imageProperty = document.get("profileImage") as! String
                
                let httpsReference = self.storage.reference(forURL: imageProperty)
                let placeholderImage = UIImage(named: "placeholder.jpg")
                image.sd_setImage(with: httpsReference, placeholderImage: placeholderImage)
                self.profileRoundImage(image)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
}
