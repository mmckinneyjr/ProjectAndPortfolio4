//
//  Event.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/12/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import Foundation
import UIKit

class Event{
    
    var title: String = ""
    var details: String = ""
    var bgImage: UIImage!
    var bgImageString: String
    var month: String
    var date: String
    var attendingGuests: [String]

    
    
    init (_title: String, _details: String, _bgImage: String, _dateString: String, _attending: [String]) {
        self.title = _title
        self.details = _details
        self.bgImageString = _bgImage
        self.attendingGuests = _attending
        
        if bgImageString.contains("http"),
            let url = URL(string: bgImageString),
            var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComp.scheme = "https"
            if let secureURL = urlComp.url {
                let imageData = try! Data.init(contentsOf: secureURL)
                self.bgImage = UIImage(data: imageData)
            }
        }
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.date(from: _dateString)
        

        formatter.dateFormat = "MMM"
        month = formatter.string(from: dateString!).uppercased()
        formatter.dateFormat = "dd"
        date = formatter.string(from: dateString!)

//        month = "123"
//        date = "456"
        
    }
    
    
    
    
    
    
    
}
