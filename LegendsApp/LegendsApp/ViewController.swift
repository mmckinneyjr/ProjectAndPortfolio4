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
        /*
        - If user is already signed in they will be take the events screen
        - Once user is signed they will need to go to the Accounts screen and signout in
          order to be able to return to the main sign in / sign up screen
        */
        if let user = Auth.auth().currentUser{
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

