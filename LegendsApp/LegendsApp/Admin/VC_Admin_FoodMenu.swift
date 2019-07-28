//  VC_Admin_FoodMenu.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/15/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.


import UIKit
import Firebase

class VC_Admin_FoodMenu: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let user = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    let globalFunc = GlobalFunctions()
    var Menu = [FoodItem]()
    var filteredMenu = [[FoodItem](), [FoodItem](), [FoodItem](), [FoodItem](), [FoodItem](), [FoodItem](), [FoodItem](), [FoodItem](), [FoodItem]()]
    
    
    
    var categories = ["starters","flatbreads","salads","soup & chili","pasties","entrees","burgers","sandwiches","desserts"]
    var category: String = "starters"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadMenu()
        UINavigationBar.appearance().titleTextAttributes = globalFunc.navTitle
        
        addItemButtonOutlet.isHidden = true
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
    }
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //UI Elements
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextView!
    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var addItemViewButton: UIView!
    @IBOutlet weak var editItemView: UIView!
    @IBOutlet weak var editItemButtonOutlet: UIButton!
    @IBOutlet weak var addItemButtonOutlet: UIButton!
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var deleteCancelView: UIView!
    @IBOutlet weak var editView: UIView!
    
    
    //Back Nav Button
    @IBAction func backNavButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Edit food items Button
    @IBAction func editButton(_ sender: Any) {
        addItemView.isHidden = true
        addItemViewButton.isHidden = true
        editItemButtonOutlet.isHidden = true
        addItemButtonOutlet.isHidden = false
        editItemView.isHidden = false
        LoadMenu()
    }
    
    //Add food items Button
    @IBAction func addButton(_ sender: Any) {
        addItemView.isHidden = false
        addItemViewButton.isHidden = false
        editItemButtonOutlet.isHidden = false
        addItemButtonOutlet.isHidden = true
        editItemView.isHidden = true
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: categories[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return attributedString
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerView.tintColor = UIColor.white
        return categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.category = categories[row]
    }
    
    @IBAction func addFoodItem(_ sender: Any) {
        let db = Firestore.firestore()
        
        if let itemTitle = itemTitleTextField.text,
            let price = priceTextField.text,
            let details = detailsTextField.text {
            
            if itemTitle.isEmpty || price.isEmpty || details.isEmpty {
                Alert(title: "Invalid", message: "Please make sure all fields are filled")
            }
                
            else{
                // Add a new document in collection "FoodMenu"
                db.collection("FoodMenu").addDocument(data: [
                    "category" : category,
                    "itemName" : itemTitle.uppercased(),
                    "price" : price,
                    "details" : details
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.Alert(title: "Complete", message: "Your item has successfully been uploaded")
                        self.itemTitleTextField.text = ""
                        self.priceTextField.text = ""
                        self.detailsTextField.text = ""
                    }
                }
            }
        }
    }
    
    
    //Alert Function
    func Alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    
    //Dismisses keyboard if tap outside keyboard area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        itemTitleTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        detailsTextField.resignFirstResponder()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filteredMenu[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "adminFoodTableView_cell", for: indexPath) as! FoodMenuCell
        let foodItems = filteredMenu[indexPath.section][indexPath.row]
        
        cell.titleLabel.text = foodItems.itemName
        cell.detailsLabel.text = foodItems.details
        cell.priceLabel.text = "$\(foodItems.price)"
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Starters"
        case 1:
            return "Flatbreads"
        case 2:
            return "Salads"
        case 3:
            return "Soup & Chili"
        case 4:
            return "Pasties"
        case 5:
            return "Entrees"
        case 6:
            return "Burgers"
        case 7:
            return "Sandwiches"
        case 8:
            return "Desserts"
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
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let f = filteredMenu[indexPath.section][indexPath.row].docID
        db.collection("FoodMenu").document(f).delete() { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.LoadMenu()
                print("Document successfully updated2")
            }
        }
    }
    
    
    
    @IBAction func deleteButton(){
        let alert = UIAlertController(title: "Delete", message: "Are sure you want you delete your photo(s)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Default action"), style: .default, handler: { _ in
            
            
            self.deleteCancelView.isHidden = true
            self.editView.isHidden = false
            
            
            if var selectedItems = self.foodTableView.indexPathsForSelectedRows {
                selectedItems.sort{(x,y) -> Bool in x.row > y.row
                }
                
                for path in selectedItems {
                    let f = self.filteredMenu[path.section][path.row].docID
                    
                    self.db.collection("FoodMenu").document(f).delete() { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        }
                            
                        else {
                            print("Document successfully updated")
                            
                            
                            switch path.section{
                            case 0: self.filteredMenu[0].remove(at: path.row)
                            case 1: self.filteredMenu[1].remove(at: path.row)
                            case 2: self.filteredMenu[2].remove(at: path.row)
                            case 3: self.filteredMenu[3].remove(at: path.row)
                            case 4: self.filteredMenu[4].remove(at: path.row)
                            case 5: self.filteredMenu[5].remove(at: path.row)
                            case 6: self.filteredMenu[6].remove(at: path.row)
                            case 7: self.filteredMenu[7].remove(at: path.row)
                            case 8: self.filteredMenu[8].remove(at: path.row)
                                
                                
                            default: print("error refreshing")
                            }
                            
                            self.foodTableView.reloadData()
                        }
                        
                    }
                }
                
                
                self.foodTableView.setEditing(false, animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButton(){
        foodTableView.setEditing(false, animated: true)
        deleteCancelView.isHidden = true
        editView.isHidden = false
    }
    
    //Edit button
    @IBAction func foodEditButton(_ sender: Any) {
        foodTableView.setEditing(true, animated: true)
        deleteCancelView.isHidden = false
        editView.isHidden = true        
    }
    
    

    
    func LoadMenu(){
        Menu = [FoodItem]()
        
        filteredMenu = [[FoodItem](), [FoodItem](), [FoodItem](), [FoodItem](), [FoodItem](), [FoodItem](), [FoodItem](), [FoodItem](), [FoodItem]()]
        
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
                        let docID = document.documentID
                        
                        self.Menu.append(FoodItem(_itemName: itemName, _details: details, _price: price, _category: category, _docID: docID))
                    }
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.filteritems()
                self.foodTableView.reloadData()
                for i in self.filteredMenu {
                    print("PRINT: \(i)")
                }
            }
        }
    }
    
    
    //Filter food items into sections
    func filteritems() {
        filteredMenu[0] = Menu.filter({ $0.category == "starters" })
        filteredMenu[1] = Menu.filter({ $0.category == "flatbreads" })
        filteredMenu[2] = Menu.filter({ $0.category == "salads" })
        filteredMenu[3] = Menu.filter({ $0.category == "soup & chili" })
        filteredMenu[4] = Menu.filter({ $0.category == "pasties" })
        filteredMenu[5] = Menu.filter({ $0.category == "entrees" })
        filteredMenu[6] = Menu.filter({ $0.category == "burgers" })
        filteredMenu[7] = Menu.filter({ $0.category == "sandwiches" })
        filteredMenu[8] = Menu.filter({ $0.category == "desserts" })
    }
    
    
}
