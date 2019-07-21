//
//  VC_SignUp.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/11/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import UIKit
//import FirebaseAuth
import Firebase





class VC_SignUp: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pImageURL = ""
    let globalFunc = GlobalFunctions()
    var imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().titleTextAttributes = globalFunc.navTitle
        
        globalFunc.roundImage(profileImageView)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    //UI Elements
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
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
    
    
    
    
    //Submit Button
    @IBAction func submitButton(_ sender: Any) {
        HandleSignUp()
    }
    
    //Cancel Button
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Dismisses keyboard if tap outside keyboard area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailAddressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    
    func HandleSignUp(){
        
        if let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailAddressTextField.text,
            let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil && user != nil {
                    print("User Created")
                    
                    guard let UID = Auth.auth().currentUser?.uid else { return }

                    self.uploadProfileImage(tempImage: self.profileImageView.image!, uid: UID, email: email, fName: firstName, lName: lastName)
                    
                    
                }
                else {
                    print("Error creating user: \(error!.localizedDescription)")
                }
            }
        }   
    }
    
    //Upload Profile Image
    func uploadProfileImage(tempImage: UIImage, uid: String, email: String, fName: String, lName: String) {
        let storageRef = Storage.storage().reference()
        // Data in memory
        let data = tempImage.jpegData(compressionQuality: 0.75)
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
                print(self.pImageURL)
                self.saveProfile(emailAddress: email, firstName: fName, lastName: lName, profileImageURL: url!.absoluteString, uid: uid)
            }
        }
    }
    
    
    func saveProfile(emailAddress: String, firstName: String, lastName: String, profileImageURL: String, uid: String) {
        let db = Firestore.firestore()
        // Add a new document in collection "cities"
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
    
    
    
}
