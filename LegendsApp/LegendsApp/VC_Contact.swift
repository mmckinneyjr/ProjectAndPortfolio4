//
//  VC_Contact.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/18/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import UIKit

class VC_Contact: UIViewController {

    let globalFunc = GlobalFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UINavigationBar.appearance().titleTextAttributes = globalFunc.navTitle
    }
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    

}
