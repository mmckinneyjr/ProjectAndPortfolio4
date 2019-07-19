//
//  VC_SignUp.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/11/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import UIKit
import FirebaseAuth

class VC_SignUp: UIViewController, UITextFieldDelegate {

    let fonts = LegendFontClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       UINavigationBar.appearance().titleTextAttributes = fonts.navTitle
        
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.cornerRadius = 75
        profileImageView.clipsToBounds = true
    }
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBAction func submitButton(_ sender: Any) {
        if let email = emailAddressTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let u = user {
                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
                }
                else {
                    
                }
            }
        }
    }
    

    //Dismisses keyboard if tap outside keyboard area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailAddressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
