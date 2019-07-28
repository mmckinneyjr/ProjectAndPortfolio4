//
//  VC_Account.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/13/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class VC_Account: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let user = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let globalFunc = GlobalFunctions()
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalFunc.roundImage(profileImageView)
        
        if user == nil {
            signInOutlet.title = "Sign In"
            imagePickerBtnOutlet.isEnabled = true
            saveSignUpBtn.setTitle("Sign Up", for: .normal)
            
        }
        else if user != nil {
            signInOutlet.title = "Sign Out"
            loadUser()
            imagePickerBtnOutlet.isEnabled = false
            saveSignUpBtn.setTitle("Save", for: .normal)
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signInOutlet: UIBarButtonItem!
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var imagePickerBtnOutlet: UIButton!
    @IBOutlet weak var saveSignUpBtn: UIButton!
    
    
    
    //User Signs out
    @IBAction func signOutButton(_ target: UIBarButtonItem) {
        if user != nil {
            signInOutlet.title = "Sign Out"
            try! Auth.auth().signOut()
        }
        self.performSegue(withIdentifier: "signOutToMainSegue", sender: self)
    }
    
    
    
    //Loads user profile information if a user is logged in
    func loadUser() {
        if user != nil {
            
            let docRef = db.collection("Users").document(user!)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {

                    let imageUrl = document.data()?["profileImage"] as? String ?? ""
                    self.firstNameOutlet.text = document.data()?["firstName"] as? String ?? ""
                    self.lastNameOutlet.text = document.data()?["lastName"] as? String ?? ""
                    self.emailOutlet.text = document.data()?["emailAddress"] as? String ?? ""
                    
                    if imageUrl.contains("http"),
                        let url = URL(string: imageUrl),
                        var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                        urlComp.scheme = "https"
                        if let secureURL = urlComp.url {
                            let imageData = try! Data.init(contentsOf: secureURL)
                            self.profileImageView.image = UIImage(data: imageData)
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
            
        }
    }
    
    
    
    
    //SIGN UP CODE
    
    
    //Selected image from picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    //Cancels Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Upload image button
    @IBAction func uploadImageButton(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}
