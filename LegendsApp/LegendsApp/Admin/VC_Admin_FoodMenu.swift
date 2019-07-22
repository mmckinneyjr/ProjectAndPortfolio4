//  VC_Admin_FoodMenu.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/15/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.


import UIKit
import Firebase

class VC_Admin_FoodMenu: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var categories = ["starters","flatbreads","entrees"]
    var category: String = "starters"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addItemButtonOutlet.isHidden = true
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
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
                        self.categoryPicker.selectRow(0, inComponent: 0, animated: true) 
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
    
    
    
    
    
    
}
