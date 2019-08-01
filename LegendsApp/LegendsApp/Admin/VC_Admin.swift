//  VC_Admin.swift
//  LegendsApp
//  Created by Mark Mckinney Jr. July 2019.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.

import UIKit

class VC_Admin: UIViewController {
    
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
