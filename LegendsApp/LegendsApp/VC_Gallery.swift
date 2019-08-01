//  VC_Gallery.swift
//  LegendsApp
//  Created by Mark Mckinney Jr. July 2019.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.

import UIKit
import Firebase
import FirebaseUI

class VC_Gallery: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    
    //Variables
    let user = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let globalFunc = GlobalFunctions()
    let refreshControl = UIRefreshControl()
    var pickedImageStore: UIImage!
    let imagePicker = UIImagePickerController()
    var thumbURLstore = ""
    var photoURLstore = ""
    var GalleryImages = [Gallery]()
    var eventID: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().titleTextAttributes = globalFunc.navTitle
        
        imagePicker.delegate = self
        
        //If user is not signed in add photo and edit buttons are not available
        if user != nil {
            photoButtonsView.isHidden = false
        }
        else if user == nil {
            photoButtonsView.isHidden = true
        }
        
        
        galleryCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        GalleryImages.removeAll()
        LoadImages()
        globalFunc.loadProfilePhoto(loggedInUserImage)
    }
    
    
    //Adds padding to collection view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        galleryCollectionView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 50, right: 0)
    }
    
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //UI ELEMENTS
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var loggedInUserImage: UIImageView!
    @IBOutlet weak var largeGalleryImage: UIImageView!
    @IBOutlet weak var photoButtonsView: UIView!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var largeGalleryButton: UIButton!
    @IBOutlet weak var largeGalleryButton2: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return largeGalleryImage
    }
    
    
    //MARK: - Collection View
    //Number of cell rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return GalleryImages.count
    }
    
    
    //Populate data into Cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell_ID", for: indexPath) as! GalleryCollectionViewCell
        
        let httpsReference = self.storage.reference(forURL: GalleryImages[indexPath.row].thumbnailString)
        let placeholderImage = UIImage(named: "loading")
        cell.galleryImage.sd_setImage(with: httpsReference, placeholderImage: placeholderImage)
        globalFunc.ImageBorder(cell.galleryImage)
        
        return cell
    }
    
    
    //this is for the size of items (user images)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var iconSize: CGFloat = 5
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad: iconSize = 5
        case .phone: iconSize = 5
        default: print("ahhhhh What kind of device is this?")
        }
        
        let width = collectionView.frame.width / iconSize
        return CGSize(width: width - 5, height: width - 5)
    }
    
    
    //these configure the spacing between items (user images)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        var imagePhoto = UIImage()
        if GalleryImages[indexPath.row].photoString.contains("http"),
            let url = URL(string: GalleryImages[indexPath.row].photoString),
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
                        self.closeLabel.isHidden = false
                        
        })
    }
    
    
    //Dismisses Large image view
    @IBAction func touchButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut,
                       animations: {self.scrollView.alpha = 0},
                       completion: { _ in self.scrollView.isHidden = true
                        
                        self.largeGalleryButton.isHidden = true
                        self.largeGalleryButton2.isHidden = true
                        self.closeLabel.isHidden = true
        })
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
                self.galleryCollectionView.reloadData()
            }
        }
    }
    
    
    //Alert to Upload image
    //Select gallery, camera, or cancel buttons
    @IBAction func addImageButton(_ sender: Any) {
        let imageUploadOption = UIAlertController(title: nil, message: "Upload Image From", preferredStyle: .actionSheet)
        
        let libraryUpload = UIAlertAction(title: "Photo Library", style: .default, handler: {(alert: UIAlertAction!) in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cameraUpload = UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        imageUploadOption.addAction(libraryUpload)
        imageUploadOption.addAction(cameraUpload)
        imageUploadOption.addAction(cancelAction)
        
        self.present(imageUploadOption, animated: true, completion: nil)
    }
    
    
    //Image Picker Selected image
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            pickedImageStore = pickedImage
            uploadImage(tempImage: pickedImageStore)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    //Upload Gallery Photos to storage
    func uploadImage(tempImage: UIImage) {
        
        let currentDate = Date()
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyyMMddHHmmssSSS"
        let dateString = format.string(from: currentDate)
        
        let storageRef = storage.reference()
        // Data in memory
        let data_thumb = tempImage.jpegData(compressionQuality: 0.001)!
        let data_photo = tempImage.jpegData(compressionQuality: 1.0)!
        
        // Create a reference to the file you want to upload
        let ref_thumb = storageRef.child("GalleryPhotos/\(dateString)_thumbnail")
        let ref_photo = storageRef.child("GalleryPhotos/\(dateString)_photo")
        
        _ = ref_thumb.putData(data_thumb, metadata: nil) { (metadata, error) in
            guard metadata != nil else { return }
            
            ref_thumb.downloadURL { (url, error) in
                guard url != nil else { return }
                self.thumbURLstore = url!.absoluteString
                self.saveImageData(uid: self.user!, photoURL: self.photoURLstore, thumbURL: self.thumbURLstore, dateName: dateString)
            }
        }
        
        let photoUpload = ref_photo.putData(data_photo, metadata: nil) { (metadata, error) in
            guard metadata != nil else { return }
            
            ref_photo.downloadURL { (url, error) in
                guard url != nil else { return }
                self.photoURLstore = url!.absoluteString
                self.saveImageData(uid: self.user!, photoURL: self.photoURLstore, thumbURL: self.thumbURLstore, dateName: dateString)
            }
        }
        
        _ = photoUpload.observe(.progress) { snapshot in
            
            self.progressView.isHidden = false
            //self.progressLabel.text =  ("\(String(format: ("\(100.0 * snapshot.progress!.fractionCompleted)%.0d")))% Complete")
            self.progressLabel.text =  "\(String(format: "%.0f", 100.0 * snapshot.progress!.fractionCompleted))% Complete"
        }
        
        // Create a task listener handle
        _ = photoUpload.observe(.success) { snapshot in
            self.progressView.isHidden = true
            self.GalleryImages.removeAll()
            self.LoadImages()
            print("Complete")
        }
        let alert = UIAlertController(title: "Upload", message: "Your photo is being upload now", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Saves profile information to Users collection in database
    func saveImageData(uid: String, photoURL: String, thumbURL: String, dateName: String) {
        let db = Firestore.firestore()
        // Add a new document in collection "Users"
        db.collection("GalleryPhotos").document(dateName).setData([
            "photo" : photoURL,
            "thumbnail" : thumbURL,
            "uploadedBy" : uid,
            "label" : dateName
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
    //Refresh Screen
    @objc func refresh() {
        GalleryImages.removeAll()
        LoadImages()
        
        refreshControl.endRefreshing()
    }
    
    
    
}


//MARK: - Gallery Object Class
class Gallery {
    
    //Stored Properties
    var thumbnailString: String = ""
    var photoString: String = ""
    var titleLable: String = ""
    var uploader: String = ""
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let dates = dateFormatter.date(from: titleLable)
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        // again convert your date to string
        let myStringafd = dateFormatter.string(from: dates!)
        return myStringafd
    }
    
    
    //Initializer
    init(_photoString: String, _thumbnailString: String, _titleLabel: String, _uploader: String) {
        self.thumbnailString = _thumbnailString
        self.photoString = _photoString
        self.titleLable = _titleLabel
        self.uploader = _uploader
    } 
}
