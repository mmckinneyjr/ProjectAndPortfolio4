//  VC_FoodMenu.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on July 2019.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.

import UIKit
import Firebase

class VC_FoodMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let user = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    let globalFunc = GlobalFunctions()
    var Menu = [FoodItem]()
    var filteredMenu = [[FoodItem](), [FoodItem](), [FoodItem]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LoadMenu()
        UINavigationBar.appearance().titleTextAttributes = globalFunc.navTitle

        
    }
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var foodTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filteredMenu[section].count
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "foodTableView_cell", for: indexPath) as! FoodMenuCell
        let foodItems = filteredMenu[indexPath.section][indexPath.row]
        
        cell.titleLabel.text = foodItems.itemName
        cell.detailsLabel.text = foodItems.details
        cell.priceLabel.text = "$\(foodItems.price)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Starters"
        case 1:
            return "Flatbreads"
        case 2:
            return "Entrees"
        default:
            return "Opps"
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Prime", size: 18)!
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = NSTextAlignment.center
        header.backgroundView?.backgroundColor = UIColor(red: 0.4392, green: 0.4392, blue: 0.4392, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    
    
    func LoadMenu(){
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            
            self.db.collection("FoodMenu").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let itemName = document.data()["itemName"] as? String ?? ""
                        let details = document.data()["details"] as? String ?? ""
                        let price = document.data()["price"] as? String ?? ""
                        let category = document.data()["category"] as? String ?? ""
                        
                        
                        self.Menu.append(FoodItem(_itemName: itemName, _details: details, _price: price, _category: category))
                    }
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.filteritems()
                self.foodTableView.reloadData()
                for i in self.filteredMenu {
                    print(i)
                }
            }
        }
    }
    
    
    //Filter food items into sections
    func filteritems() {
        filteredMenu[0] = Menu.filter({ $0.category == "starters" })
        filteredMenu[1] = Menu.filter({ $0.category == "flatbreads" })
        filteredMenu[2] = Menu.filter({ $0.category == "entrees" })
    }
    
    
    
    
    
    
    
    

}
