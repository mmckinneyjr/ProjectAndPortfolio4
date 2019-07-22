//
//  FontClass.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/12/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class GlobalFunctions {
    
    
    
    let navTitle = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Prime", size: 20)!]
    
    
    func roundImage(_ image: UIImageView){
        image.layer.borderWidth = 2
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    

    
    
}
