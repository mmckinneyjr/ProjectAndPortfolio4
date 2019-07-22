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
    
    let globalFunc = GlobalFunctions()

    override func viewDidLoad() {
        super.viewDidLoad()

        globalFunc.roundImage(profileImageView)
        
    }
    

    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBAction func signOutButton(_ target: UIBarButtonItem) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "signOutToMainSegue", sender: self)

    }
    
}
