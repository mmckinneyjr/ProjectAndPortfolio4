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

class VC_Account: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

 
    
    @IBAction func signOutButton(_ target: UIBarButtonItem) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "signOutToMainSegue", sender: self)

    }
    
}
