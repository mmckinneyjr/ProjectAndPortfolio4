//  User.swift
//  LegendsApp
//  Created by Mark Mckinney Jr. July 2019.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.

import Foundation
import UIKit

class User {
    
    var UID: String
    var fName: String
    var lName: String
    var email: String
    var profileImageURL: String
    
    
    init(_UID: String, _fName: String, _lName: String, _profileImageURL: String, _email: String) {
        self.UID = _UID
        self.fName = _fName
        self.lName = _lName
        self.lName = _lName
        self.email = _email
        self.profileImageURL = _profileImageURL
    }
    
    
    
}
