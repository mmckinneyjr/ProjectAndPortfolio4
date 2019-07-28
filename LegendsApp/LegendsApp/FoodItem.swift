//
//  FoodItem.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/15/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import Foundation

class FoodItem {
    
    var itemName: String
    var details: String
    var price: String
    var category: String
    var docID: String
    
    init(_itemName: String, _details: String, _price: String, _category: String, _docID: String) {
        self.itemName = _itemName
        self.details = _details
        self.price = _price
        self.category = _category
        self.docID = _docID
    }
    
    
    
    
}
