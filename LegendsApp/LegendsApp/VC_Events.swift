//
//  VC_Events.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/11/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import UIKit
import Firebase


class VC_Events: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let fonts = LegendFontClass()
    
    let db = Firestore.firestore()
    var Events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().titleTextAttributes = fonts.navTitle
        
        LoadEvents()
        
        
    }
    
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //UI ELEMENTS
    @IBOutlet weak var eventsTableView: UITableView!
    
    @IBOutlet weak var loggedInUserImage: UIImageView!
    
    
    
    //Downloads event info into Events array
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
                        let bgImage = document.data()["image"] as? String ?? ""
                        let date = document.data()["date"] as? String ?? ""
                        let moreDetails = document.data()["moreDetails"] as? String ?? ""
                        let attendingGuests = document["attending"] as? Array ?? [""]

                        
                        self.Events.append(Event(_title: title, _details: details, _bgImage: bgImage, _dateString: date, _attending: attendingGuests, _moreDetails: moreDetails))
                    }
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.eventsTableView.reloadData()
//                for i in self.Events {
//                    print("\(i): \(i.moreDetails)\n")
//                }
            }
        }
    }
        
    
    //Number of cell rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return Events.count
    }
    
    //Cell Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 200
    }

    //Populate data into Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ID", for: indexPath) as! EventCell

        cell.titleLabel.text = Events[indexPath.row].title
        cell.detailsLabel?.text = Events[indexPath.row].details
        cell.cellBG.image = Events[indexPath.row].bgImage
        cell.monthLabel.text = Events[indexPath.row].month
        cell.dateLabel.text = Events[indexPath.row].date

        cell.attendingCount = Events[indexPath.row].attendingGuests.count
        
        return cell
    }

 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = eventsTableView.indexPathForSelectedRow {
            let destination = segue.destination as? VC_EventDetails
            destination?.detailsBGImage = Events[indexPath.row].bgImage
            destination?.detailsDate = Events[indexPath.row].fullDate
            destination?.detailsTitle = Events[indexPath.row].title
            destination?.detailsDetails = Events[indexPath.row].details
            destination?.detailsMoreDetails = Events[indexPath.row].moreDetails
            eventsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    


    

    
        
        
}
