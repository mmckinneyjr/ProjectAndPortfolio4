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
    
    let user = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let globalFunc = GlobalFunctions()
    
    var Events = [Event]()
    var eventID: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadEvents()
        globalFunc.loadProfilePhoto(loggedInUserImage)

        UINavigationBar.appearance().titleTextAttributes = globalFunc.navTitle
    }
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //UI ELEMENTS
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var loggedInUserImage: UIImageView!
    @IBOutlet weak var loadingIndicatorView: UIView!
    
    
    
    //Downloads event info into Events array
    func LoadEvents(){
        let group = DispatchGroup()
        group.enter()
        
            self.loadingIndicatorView.isHidden = false
            
            
            self.db.collection("Events").getDocuments(source: .default) { (querySnapshot, err) in
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
                        let eventTitle = document.documentID
                        
                        self.Events.append(Event(_title: title, _details: details, _bgImage: bgImage, _dateString: date, _attending: attendingGuests, _moreDetails: moreDetails, _eventTitle: eventTitle))
                    }
                }
                group.leave()
            
            
            group.notify(queue: .main) {
                self.Events.sort(by: { $0.eventTitle < $1.eventTitle })
                self.eventsTableView.reloadData()
                self.loadingIndicatorView.isHidden = true
            }
        }
    }
        
    
    //Number of cell rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Events.count
    }
    
    //Cell Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 200
    }

    
    
    
    
    //Populate data into Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ID", for: indexPath) as! EventCell
        
     
        
        cell.eventID = Events[indexPath.row].eventTitle
        cell.titleLabel.text = Events[indexPath.row].title
        cell.detailsLabel?.text = Events[indexPath.row].details
        cell.cellBG.image = Events[indexPath.row].bgImage
        cell.monthLabel.text = Events[indexPath.row].month
        cell.dateLabel.text = Events[indexPath.row].date

        cell.attendingCount = Events[indexPath.row].attendingGuests.count
        cell.eventID = Events[indexPath.row].eventTitle
        cell.attendingingUIDs = Events[indexPath.row].attendingGuests
        
        
        if cell.attendingCount <= 10 {
            cell.attendingCountLabel.isHidden = true
        }
        else if cell.attendingCount > 10 {
            cell.attendingCountLabel.isHidden = false
            cell.attendingCountLabel.text = "+ \((cell.attendingCount - 10).description)"
        }
        
        cell.attendingCollection.reloadData()
        print("\(Events[indexPath.row].eventTitle): \(Events[indexPath.row].attendingGuests.count)")
        
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
            destination?.eventTitle = Events[indexPath.row].eventTitle
            
            destination?.attendingUID = Events[indexPath.row].attendingGuests

            eventsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    

    

    
        
        
}




