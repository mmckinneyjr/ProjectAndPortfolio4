//
//  VC_AdminEvents.swift
//  BoringSSL-GRPC
//
//  Created by Mark Mckinney Jr. on 7/25/19.
//

import UIKit
import Firebase

class VC_AdminEvents: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var pImageURL:String? = nil
    let globalFunc = GlobalFunctions()
    var imagePicker = UIImagePickerController()
    var tempDocTitle_time: String? = nil
    var tempEventTitle_time: String? = nil
    
    var EventImages = [Event]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().titleTextAttributes = globalFunc.navTitle
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        datePickerOutlet.setValue(UIColor.white, forKey: "textColor")
    }
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var BGImageView: UIImageView!
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var eventDetailTextField: UITextField!
    @IBOutlet weak var eventMoreDetailsTextBox: UITextView!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
        @IBOutlet weak var galleryEditTableView: UITableView!
    @IBOutlet weak var deleteCancelView: UIView!
    @IBOutlet weak var editBtnOutlet: UIButton!
    @IBOutlet weak var addBtnOutlet: UIButton!
    
    @IBOutlet weak var barEditOutlet: UIView!
    @IBOutlet weak var barDeleteCancelOutlet: UIView!
    
    
    //MARK: - Picker
    //Selected image from picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            BGImageView.contentMode = .scaleAspectFill
            BGImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    //Cancels Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        let dateString = dateFormatter.string(from: datePickerOutlet.date)
        
        //Convert date picker date to full date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        let dateForm = formatter.date(from: dateString)
        
        //convert full date to needed string
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy_MM_dd"
        tempDocTitle_time = dateFormatter.string(from: dateForm!)
        print("DATE1: \(tempDocTitle_time ?? "")")
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        tempEventTitle_time = dateFormatter.string(from: dateForm!)
        print("DATE2: \(tempEventTitle_time ?? "")")
        
        
    }
    
    //Image Picker button - presents image picker
    @IBAction func imagePickerButton(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    //add event view add event button
    @IBAction func addEventButton(_ sender: Any) {
        HandleTableViewLoad()
    }
    
    
    
    
    
    //footer edit button
    @IBAction func editFooterButton(_ sender: Any) {
        LoadImages()
        addBtnOutlet.isHidden = false
        editBtnOutlet.isHidden = true
        galleryEditTableView.isHidden = false
        deleteCancelView.isHidden = false
    }
    
    //footer add button
    @IBAction func addFooterButton(_ sender: Any) {
        addBtnOutlet.isHidden = true
        editBtnOutlet.isHidden = false
        galleryEditTableView.isHidden = true
        deleteCancelView.isHidden = true
    }


    
    
    //Cancel button
    @IBAction func barEditButton(){
        galleryEditTableView.setEditing(true, animated: true)
        barEditOutlet.isHidden = true
    }
    
    
    //Cancel button
    @IBAction func barCancelButton(){
        galleryEditTableView.setEditing(false, animated: true)
        barEditOutlet.isHidden = false
    }
    
    
    
    
    

    //Back button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func HandleTableViewLoad() {
        if let title = eventTitleTextField.text,
            let details = eventDetailTextField.text,
            let moreDetails = eventMoreDetailsTextBox.text  {
            
            if tempEventTitle_time == nil {
                self.Alert(title: "Invalid", message: "Please make sure to select a date")
            }
            
            //Alert if all fields are not filled
            else if title.isEmpty == true || details.isEmpty == true || moreDetails.isEmpty == true {
                self.Alert(title: "Invalid", message: "Please make sure all text fields are filled")
            }
                //Alert if user does not upload a profile image
            else if BGImageView.image == nil {
                self.Alert(title: "Invalid", message: "Please make sure you upload an event photo")
            }
                
            else {
                self.uploadEventImage(tempImage: BGImageView.image!, title: title, details: details, dateString: tempEventTitle_time ?? "", attending: [], moreDetails: moreDetails, eventTitle: tempDocTitle_time ?? "")
                
                eventTitleTextField.text = ""
                eventDetailTextField.text = ""
                eventMoreDetailsTextBox.text = ""
                BGImageView.image = nil
                tempEventTitle_time = nil
                
                self.Alert(title: "Success", message: "Your event has been uploaded")
            }
        }
    }
    
    
    
    
    //Upload Profile Image
    func uploadEventImage(tempImage: UIImage, title: String, details: String, dateString: String, attending: [String], moreDetails: String, eventTitle: String) {
        let storageRef = Storage.storage().reference()
        // Data in memory
        let data = tempImage.jpegData(compressionQuality: 0.5)
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("EventBGImages/image-\(tempDocTitle_time ?? "")")
        // Upload the file to the path "images/rivers.jpg"
        _ = riversRef.putData(data!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else { return }
            // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard url != nil else { return }
                self.pImageURL = url!.absoluteString
                print(self.pImageURL!)
                self.saveProfile(title: title, details: details, bgImage: self.pImageURL ?? "", dateString: dateString, attending: attending, moreDetails: moreDetails, eventTitle: eventTitle)
            }
        }
    }
    
    //Saves profile information to Users collection in database
    func saveProfile(title: String, details: String, bgImage: String, dateString: String, attending: [String], moreDetails: String, eventTitle: String) {
        let db = Firestore.firestore()
        // Add a new document in collection "Users"
        db.collection("Events").document(eventTitle).setData([
            "title" : title,
            "details" : details,
            "moreDetails" : moreDetails,
            "image" : bgImage,
            "date" : dateString,
            "attending" : []
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
    
    //Dismisses keyboard if tap outside keyboard area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        eventTitleTextField.resignFirstResponder()
        eventDetailTextField.resignFirstResponder()
        eventMoreDetailsTextBox.resignFirstResponder()
    }
    
    //Alert Function
    func Alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    

    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = galleryEditTableView.dequeueReusableCell(withIdentifier: "adminEventEdit_ID", for: indexPath) as! GalleryEditCollectionViewCell
        
        let httpsReference = self.storage.reference(forURL: EventImages[indexPath.row].bgImageString)
        let placeholderImage = UIImage(named: "attendingPlaceHolder")
        cell.galleryEditImages.sd_setImage(with: httpsReference, placeholderImage: placeholderImage)
        cell.dateLabel.text = EventImages[indexPath.row].title
        globalFunc.ImageBorder(cell.galleryEditImages)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    

    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete", message: "Are sure you want you delete your photo(s)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Default action"), style: .default, handler: { _ in
            
        
            let f = self.EventImages[indexPath.row].eventTitle
            
        //Deletes the actual photo from storage
        let thumbRef = self.storage.reference().child("EventBGImages/image-\(f)")
        thumbRef.delete { error in
            if let error = error { print("Error deleting thumbnail: \(error)") } else { print("") }
        }
        
        //Deletes the reference to the photo
            self.db.collection("Events").document(f).delete() { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
            self.EventImages.remove(at: indexPath.row)
        self.galleryEditTableView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Delete Button
    @IBAction func deleteButton(){
        let alert = UIAlertController(title: "Delete", message: "Are sure you want you delete your photo(s)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Default action"), style: .default, handler: { _ in
                        
            self.barEditOutlet.isHidden = false
            
            if var selectedItems = self.galleryEditTableView.indexPathsForSelectedRows {
                selectedItems.sort{(x,y) -> Bool in x.row > y.row
                }
                
                for path in selectedItems {
                    let f = self.EventImages[path.row].eventTitle
                    
                    
                    //Deletes the actual photo from storage
                    let thumbRef = self.storage.reference().child("EventBGImages/image-\(f)")
                    thumbRef.delete { error in
                        if let error = error { print("Error deleting thumbnail: \(error)") } else { print("") }
                    }

                    
                    //Deletes the reference to the photo
                    self.db.collection("Events").document(f).delete() { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                    
                    self.EventImages.remove(at: path.row)
                }
                
                self.galleryEditTableView.deleteRows(at: selectedItems, with: .left)
                self.galleryEditTableView.reloadData()
                
                self.galleryEditTableView.setEditing(false, animated: true)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

    
    
    
    
    //Downloads event info into Events array
    func LoadImages(){
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            
            self.db.collection("Events").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let date = document.data()["date"] as? String ?? ""
                        let photo = document.data()["image"] as? String ?? ""
                        let title = document.data()["title"] as? String ?? ""
                        let eventTitle = document.documentID


                        
                        self.EventImages.append(Event(_title: title, _details: "", _bgImage: photo, _dateString: date, _attending: [], _moreDetails: "", _eventTitle: eventTitle))
                    }
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.EventImages.sort(by: { $0.eventTitle < $1.eventTitle })
                self.galleryEditTableView.reloadData()
            }
        }
    }
    
    
    

    

    
}
