//  Event.swift
//  LegendsApp
//  Created by Mark Mckinney Jr. July 2019.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.

import Foundation
import UIKit

class Event {
    
    var title: String = ""
    var details: String = ""
    var bgImage: UIImage!
    var bgImageString: String
    var month: String
    var date: String
    var year: String = ""
    var attendingGuests: [String]
    var moreDetails: String
    var eventTitle: String = ""
    
    var fullDate: String{
        return "\(date) \(month) \(year)"
    }
    
    
    init (_title: String, _details: String, _bgImage: String, _dateString: String, _attending: [String], _moreDetails: String, _eventTitle: String) {
        self.title = _title
        self.details = _details
        self.bgImageString = _bgImage
        self.attendingGuests = _attending
        self.moreDetails = _moreDetails
        self.eventTitle = _eventTitle
        
        
        if bgImageString.contains("http"),
            let url = URL(string: bgImageString),
            var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComp.scheme = "https"
            if let secureURL = urlComp.url {
                if let imageData = try? Data.init(contentsOf: secureURL) {
                    self.bgImage = UIImage(data: imageData)
                }
            }
        }
        
        
        //Sets date string into date object
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.date(from: _dateString)
        
        //Sets data object back to individual strings
        formatter.dateFormat = "MMM"
        month = formatter.string(from: dateString!).uppercased() 
        formatter.dateFormat = "dd"
        date = formatter.string(from: dateString!)
        formatter.dateFormat = "yyyy"
        year = formatter.string(from: dateString!)
    }
    
    
}
