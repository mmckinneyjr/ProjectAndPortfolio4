//  VC_GalleryEdits.swift
//  LegendsApp
//  Created by Mark Mckinney Jr. July 2019.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.

import UIKit
import Firebase

class VC_GalleryEdits: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Variables
    let user = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let globalFunc = GlobalFunctions()
    var GalleryImages = [Gallery]()
    var FilteredGallery = [Gallery]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadImages()
        
        galleryEditTableView.allowsMultipleSelectionDuringEditing = true
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
    
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return largeGalleryImage
    }
    
    
    //UI elements
    @IBOutlet weak var galleryEditTableView: UITableView!
    @IBOutlet weak var deleteCancelView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var largeGalleryImage: UIImageView!
    @IBOutlet weak var largeGalleryImageView: UIView!
    @IBOutlet weak var largeGalleryButton: UIButton!
    @IBOutlet weak var largeGalleryButton2: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeIconLabel: UILabel!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        galleryEditTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilteredGallery.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = galleryEditTableView.dequeueReusableCell(withIdentifier: "galleryEdit_ID", for: indexPath) as! GalleryEditCollectionViewCell
        
        let httpsReference = self.storage.reference(forURL: FilteredGallery[indexPath.row].thumbnailString)
        let placeholderImage = UIImage(named: "loading")
        cell.galleryEditImages.sd_setImage(with: httpsReference, placeholderImage: placeholderImage)
        cell.dateLabel.text = FilteredGallery[indexPath.row].date
        globalFunc.ImageBorder(cell.galleryEditImages)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let f = FilteredGallery[indexPath.row].titleLable
        
        //Deletes the actual photo from storage
        let thumbRef = self.storage.reference().child("GalleryPhotos/\(f)_thumbnail")
        let photoRef = self.storage.reference().child("GalleryPhotos/\(f)_photo")
        thumbRef.delete { error in
            if let error = error { print("Error deleting thumbnail: \(error)") } else { print("") }
        }
        photoRef.delete { error in
            if let error = error { print("Error deleting photo: \(error)") } else { print("") }
        }
        
        //Deletes the reference to the photo
        db.collection("GalleryPhotos").document(f).delete() { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        FilteredGallery.remove(at: indexPath.row)
        self.galleryEditTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if galleryEditTableView.isEditing == false {
            var imagePhoto = UIImage()
            if FilteredGallery[indexPath.row].photoString.contains("http"),
                let url = URL(string: FilteredGallery[indexPath.row].photoString),
                var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                urlComp.scheme = "https"
                if let secureURL = urlComp.url {
                    if let imageData = try? Data.init(contentsOf: secureURL) {
                        imagePhoto = UIImage(data: imageData)!
                    }
                }
            }
            
            largeGalleryImage.image = imagePhoto
            
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut,
                           animations: {self.scrollView.alpha = 1.0},
                           completion: { _ in self.scrollView.isHidden = false
                            
                            self.largeGalleryButton.isHidden = false
                            self.largeGalleryButton2.isHidden = false
                            self.closeIconLabel.isHidden = false
                            
            })
            
            self.galleryEditTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    //Dismisses Large image view
    @IBAction func touchButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut,
                       animations: {self.scrollView.alpha = 0},
                       completion: { _ in self.scrollView.isHidden = true
                        
                        self.largeGalleryButton.isHidden = true
                        self.largeGalleryButton2.isHidden = true
                        self.closeIconLabel.isHidden = true
        })
        
        scrollView.zoomScale = 1.0
    }
    
    
    @IBAction func deleteButton(){
        let alert = UIAlertController(title: "Delete", message: "Are sure you want yo delete your photo(s)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Default action"), style: .default, handler: { _ in
            
            self.deleteCancelView.isHidden = true
            self.editView.isHidden = false
            
            if var selectedItems = self.galleryEditTableView.indexPathsForSelectedRows {
                selectedItems.sort{(x,y) -> Bool in x.row > y.row
                }
                
                for path in selectedItems {
                    
                    let f = self.FilteredGallery[path.row].titleLable
                    
                    //Deletes the actual photo from storage
                    let thumbRef = self.storage.reference().child("GalleryPhotos/\(f)_thumbnail")
                    let photoRef = self.storage.reference().child("GalleryPhotos/\(f)_photo")
                    thumbRef.delete { error in
                        if let error = error { print("Error deleting thumbnail: \(error)") } else { print("") }
                    }
                    photoRef.delete { error in
                        if let error = error { print("Error deleting photo: \(error)") } else { print("") }
                    }
                    
                    //Deletes the reference to the photo
                    self.db.collection("GalleryPhotos").document(f).delete() { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                    self.FilteredGallery.remove(at: path.row)
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
            
            self.db.collection("GalleryPhotos").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let thumb = document.data()["thumbnail"] as? String ?? ""
                        let photo = document.data()["photo"] as? String ?? ""
                        let label = document.data()["label"] as? String ?? ""
                        let uploader = document.data()["uploadedBy"] as? String ?? ""
                        
                        self.GalleryImages.append(Gallery(_photoString: photo, _thumbnailString: thumb, _titleLabel: label, _uploader: uploader))
                    }
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.GalleryImages.sort(by: { $0.titleLable > $1.titleLable })
                self.filteritems()
                self.galleryEditTableView.reloadData()
            }
        }
    }
    
    
    //Gallery Back Buttoon
    @IBAction func galleryBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Back Button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButton(){
        galleryEditTableView.setEditing(false, animated: true)
        deleteCancelView.isHidden = true
        editView.isHidden = false
    }
    
    
    //Edit button
    @IBAction func editButton(_ sender: Any) {
        galleryEditTableView.setEditing(true, animated: true)
        deleteCancelView.isHidden = false
        editView.isHidden = true
    }
    
    
    func filteritems() {
        FilteredGallery = GalleryImages.filter({ $0.uploader == user })
    }
    
    
}




