//
//  VC_GalleryEdits.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/20/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import UIKit
import Firebase

class VC_GalleryEdits: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    

    let user = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let globalFunc = GlobalFunctions()
    
    var GalleryImages = [Gallery]()
    var FilteredGallery = [Gallery]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadImages()
        
        
        
    }
    
    
    @IBOutlet weak var collectionImage: UICollectionView!    
    @IBOutlet weak var editCollectionView: UICollectionView!
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        editCollectionView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 50, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilteredGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = editCollectionView.dequeueReusableCell(withReuseIdentifier: "galleryEditCell_ID", for: indexPath) as! GalleryEditCollectionViewCell
        
        
        let httpsReference = self.storage.reference(forURL: FilteredGallery[indexPath.row].thumbnailString)
        let placeholderImage = UIImage(named: "placeholder.jpg")
        cell.galleryEditImages.sd_setImage(with: httpsReference, placeholderImage: placeholderImage)
        
        globalFunc.ImageBorder(cell.galleryEditImages)
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
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
                self.editCollectionView.reloadData()
                for i in self.GalleryImages {
                    print(i.titleLable)
                }
            }
        }
    }
    
    
    

    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func filteritems() {
        FilteredGallery = GalleryImages.filter({ $0.uploader == user })
    }


}




