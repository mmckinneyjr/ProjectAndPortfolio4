//
//  VC_EventDetails.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/12/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//
import Foundation
import UIKit

class VC_EventDetails: UIViewController {

    var detailsBGImage = UIImage()
    var detailsDate = ""
    var detailsTitle = ""
    var detailsDetails = ""
    var detailsMoreDetails = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        BGImage.image = detailsBGImage
        dateLabel.text = detailsDate
        titleLabel.text = detailsTitle
        detailsLabel.text = detailsDetails
        moreDetailsLabel.text = detailsMoreDetails
        

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = BGImage.bounds
        BGImage.addSubview(blurView)
        
    }
    

    @IBOutlet weak var BGImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreDetailsLabel: UITextView!
    

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
