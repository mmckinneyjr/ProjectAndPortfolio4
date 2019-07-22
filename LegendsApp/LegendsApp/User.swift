//
//  User.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/14/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var UID: String
    var fName: String
    var lName: String
    var profileImageURL: String
    
    init(_UID: String, _fName: String, _lName: String, _profileImageURL: String) {
        self.UID = _UID
        self.fName = _fName
        self.lName = _lName
        self.profileImageURL = _profileImageURL
    }
    
    
    
}
