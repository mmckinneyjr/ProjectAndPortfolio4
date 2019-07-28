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
        image.contentMode = .scaleAspectFill
    }
    
    func roundImage2(_ image: UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.layer.borderColor = UIColor(red:225/255, green:107/255, blue:55/255, alpha: 1).cgColor
        image.contentMode = .scaleAspectFill
    }
    
    func roundImage3(_ image: UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        image.layer.borderColor = UIColor(red:225/255, green:107/255, blue:55/255, alpha: 1).cgColor
        image.contentMode = .scaleAspectFill
    }
    
    func ImageBorder(_ image: UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.contentMode = .scaleAspectFill
    }
    
    func profileRoundImage(_ image: UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
    }
    
    
    
    

    
    
    func loadProfilePhoto(_ proImage: UIImageView){
        if user != nil {
            
          
            let docRef = db.collection("Users").document(user!)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    let imageUrl = document.data()?["profileImage"] as? String ?? ""

                    if imageUrl.contains("http"),
                        let url = URL(string: imageUrl),
                        var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                        urlComp.scheme = "https"
                        if let secureURL = urlComp.url {
                            guard let imageData = try? Data.init(contentsOf: secureURL) else { return }
                            proImage.image = UIImage(data: imageData)
                            self.profileRoundImage(proImage)
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
            
            
            
            
            
        }
    }
    
    
    
    
    
    
    
//    func loadProfilePhoto(_ image: UIImageView){
//        if user != nil {
//
//            let docRef = db.collection("Users").document(user!)
//            docRef.getDocument(source: .server) { (document, error) in
//                if let document = document {
//                    guard let imageProperty = document.get("profileImage") as? String else { return }
//
//                    let httpsReference = self.storage.reference(forURL: imageProperty)
//                    let placeholderImage = UIImage(named: "attendingPlaceHolder")
//
//                    image.sd_setImage(with: httpsReference, placeholderImage: placeholderImage)
//                    self.profileRoundImage(image)
//
//                } else {
//                    print("Document does not exist")
//                }
//            }
//        }
//    }
    
    
}
