//  VC_Account.swift
//  LegendsApp
//  Created by Mark Mckinney Jr. July 2019.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class VC_Account: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Variables
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let globalFunc = GlobalFunctions()
    var imagePicker = UIImagePickerController()
    var pImageURL:String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user?.uid == "h9kOfVBW8wbPdEwYpLnsDOidLvU2" {
            AdminOutlet.isHidden = false
        }
        
        UINavigationBar.appearance().titleTextAttributes = globalFunc.navTitle
        
        globalFunc.roundImage(profileImageView)
        
        if user == nil {
            signInOutlet.title = "Sign In"
            signUpOutlet.isHidden = false
            saveOutlet.isHidden = true
        }
        else if user != nil {
            signInOutlet.title = "Sign Out"
            signUpOutlet.isHidden = true
            saveOutlet.isHidden = false
            loadUser()
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //UI Elements
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signInOutlet: UIBarButtonItem!
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var imagePickerBtnOutlet: UIButton!
    @IBOutlet weak var signUpOutlet: UIButton!
    @IBOutlet weak var saveOutlet: UIButton!
    @IBOutlet weak var AdminOutlet: UIButton!
    
    
    @IBAction func saveButton(_ sender: Any) {
        let alert = UIAlertController(title: "Update Info", message: "Are sure want to make these changes?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Update?", comment: "Default action"), style: .default, handler: { _ in
            
            //Change password
            if self.passwordOutlet.text != nil && self.passwordOutlet.text != "" {
                if self.passwordOutlet.text != "" || self.passwordOutlet != nil {
                    self.user?.updatePassword(to: self.passwordOutlet.text ?? "") { error in
                        if let error = error {
                            print(error)
                            self.Alert(title: "Invalid", message: error.localizedDescription)
                        }
                        else {
                            print("Password Saved Successfully")
                        }
                    }
                }
            }
            
            //change email
            if self.emailOutlet != nil && self.emailOutlet.text != "" {
                self.user?.updateEmail(to: self.emailOutlet.text ?? "") { error in
                    if let error = error {
                        print(error)
                        self.Alert(title: "Invalid", message: error.localizedDescription)
                    }
                    else {
                        
                        self.uploadProfileImage(tempImage: self.profileImageView.image ?? UIImage(named: "uploadImage")!, uid: self.user!.uid, email: self.emailOutlet.text ?? "", fName: self.firstNameOutlet.text ?? "", lName: self.lastNameOutlet.text ?? "")
                        Auth.auth().currentUser?.updatePassword(to: self.passwordOutlet.text ?? "", completion: nil)
                        
                        print("Email Address Saved Successfully")
                    }
                }
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        HandleSignUp()
    }
    
    
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
            
            let docRef = db.collection("Users").document(user!.uid)
            
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
    
    
    //Dismisses keyboard if tap outside keyboard area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstNameOutlet.resignFirstResponder()
        lastNameOutlet.resignFirstResponder()
        emailOutlet.resignFirstResponder()
        passwordOutlet.resignFirstResponder()
    }
    
    
    //Uploads profile to database
    func HandleSignUp() {
        if let firstName = firstNameOutlet.text,
            let lastName = lastNameOutlet.text,
            let email = emailOutlet.text,
            let password = passwordOutlet.text {
            
            //Alert if all fields are not filled
            if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty{
                self.Alert(title: "Invalid", message: "Please make sure all fields are filled")
            }
                //Alert if user does not upload a profile image
            else if profileImageView == nil || profileImageView.image == UIImage(named: "uploadImage") {
                self.Alert(title: "Invalid", message: "Please make sure you upload a profile photo")
            }
                
            else {
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if error == nil && user != nil {
                        
                        guard let UID = Auth.auth().currentUser?.uid else { return }
                        self.uploadProfileImage(tempImage: self.profileImageView.image!, uid: UID, email: email, fName: firstName, lName: lastName)
                        
                        print("User Created")
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        //Alert if user email already taked, password too short.
                        self.Alert(title: "Invalid", message: error!.localizedDescription)
                        print("Error creating user: \(error!.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
    //Upload Profile Image
    func uploadProfileImage(tempImage: UIImage, uid: String, email: String, fName: String, lName: String) {
        let storageRef = Storage.storage().reference()
        // Data in memory
        let data = tempImage.jpegData(compressionQuality: 0.5)
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("UserProfileImages/\(uid)")
        // Upload the file to the path "images/rivers.jpg"
        _ = riversRef.putData(data!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else { return }
            // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard url != nil else { return }
                self.pImageURL = url!.absoluteString
                print(self.pImageURL!)
                self.saveProfile(emailAddress: email, firstName: fName, lastName: lName, profileImageURL: url!.absoluteString, uid: uid)
            }
        }
    }
    
    
    //Saves profile information to Users collection in database
    func saveProfile(emailAddress: String, firstName: String, lastName: String, profileImageURL: String, uid: String) {
        let db = Firestore.firestore()
        // Add a new document in collection "Users"
        db.collection("Users").document(uid).setData([
            "emailAddress" : emailAddress,
            "firstName" : firstName,
            "lastName" : lastName,
            "profileImage" : profileImageURL
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
    //Alert Function
    func Alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
