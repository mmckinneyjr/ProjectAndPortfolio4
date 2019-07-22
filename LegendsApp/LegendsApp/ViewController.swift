//
//  ViewController.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/11/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

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

        let user = Auth.auth().currentUser
        if user != nil {
            self.performSegue(withIdentifier: "signUpToEventsSegue", sender: self)
        }
    }
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var usernameTextField: UITextField!    
    @IBOutlet weak var passwordTextField: UITextField!
    
    

    
    //Dismisses keyboard if tap outside keyboard area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if let email = usernameTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil && user != nil {
                    self.performSegue(withIdentifier: "signInSegue", sender: self)
                }
                else {
                    print("Error logging in: \(error!.localizedDescription)")
                }
            }
        }
    }
    
    
}

