//  ViewController.swift
//  LegendsApp
//  Created by Mark Mckinney Jr. July 2019.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.

import Foundation
import UIKit
import Firebase



class ViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = Auth.auth().currentUser {
            if user.uid == "h9kOfVBW8wbPdEwYpLnsDOidLvU2" {
                self.performSegue(withIdentifier: "adminSigninSegue", sender: self)
            }
                
            else {
                self.performSegue(withIdentifier: "signUpToEventsSegue", sender: self)
            }
        }
    }
    
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //UI elements
    @IBOutlet weak var usernameTextField: UITextField!    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //Dismisses keyboard if tap outside keyboard area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    //Log in button
    @IBAction func loginButton(_ sender: Any) {
        logInHandler()
    }
    
    
    @IBAction func forgotPassword(_ sender: Any) {
        let alert = UIAlertController(title: "Please enter your email address", message: "Please provide your email address and we will send you a link to reset your password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."
        })
        
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { action in
            
            if let email = alert.textFields?.first?.text {
                Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                    if error == nil {
                    }
                }
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    
    //Switch from one textfield to another
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            logInHandler()
        }
        return true
    }
    
    
    func logInHandler(){
        if let email = usernameTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                guard self != nil else { return }
                
                if error == nil && user != nil {
                    self?.performSegue(withIdentifier: "signInSegue", sender: self)
                }
                else {
                    self?.Alert(title: "Incorrect email address or password", message: "The email address or password you entered is incorrect. Please try again")
                    print("Error logging in: \(error!.localizedDescription)")
                }
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

