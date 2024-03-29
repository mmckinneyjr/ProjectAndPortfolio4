//  VC_SignUp.swift
//  LegendsApp
//  Created by Mark Mckinney Jr. July 2019.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.

import UIKit
import Firebase


class VC_SignUp: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Variables
    var pImageURL:String? = nil
    let globalFunc = GlobalFunctions()
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().titleTextAttributes = globalFunc.navTitle
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
        
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
    
    
    //MARK: - Buttons
    //Submit Button
    @IBAction func submitButton(_ sender: Any) {
        HandleSignUp()
    }
    
    
    //Cancel Button
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Picker
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
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailAddressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    //Uploads profile to database
    func HandleSignUp() {
        if let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailAddressTextField.text,
            let password = passwordTextField.text {
            
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
    
    
    //Switch from one textfield to another
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            textField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
        }
        else if textField == lastNameTextField {
            textField.resignFirstResponder()
            emailAddressTextField.becomeFirstResponder()
        }
        else if textField == emailAddressTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            textField.resignFirstResponder()
            HandleSignUp()
        }
        return true
    }
    
    
    //Alert Function
    func Alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
