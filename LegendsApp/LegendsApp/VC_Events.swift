//
//  VC_Events.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/11/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import UIKit
import Firebase


class VC_Events: UIViewController {
    
    let db = Firestore.firestore()
    var Events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        LoadEvents()
        
    }
    
    
    @IBAction func button(_ sender: Any) {
        testLabel.text = Events[0].title
    }
    
    
    @IBOutlet weak var testLabel: UILabel!
    
    
    
    
    func LoadEvents(){
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            
            
            self.db.collection("Events").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let title = document.data()["title"] as? String ?? ""
                        let details = document.data()["details"] as? String ?? ""
                        
                        print(title)
                        self.Events.append(Event(_title: title, _details: details))
                    }
                }
                group.leave()
                
            }
            
            
            group.notify(queue: .main) {
                print(self.Events[0].title)
            }
            
        }
        
    }
        
        
        
        
        
        
        
}
