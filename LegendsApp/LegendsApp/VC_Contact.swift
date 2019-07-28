//
//  VC_Contact.swift
//  LegendsApp
//
//  Created by Mark Mckinney Jr. on 7/18/19.
//  Copyright © 2019 Mark Mckinney Jr. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class VC_Contact: UIViewController, MFMailComposeViewControllerDelegate {
    
    let user = Auth.auth().currentUser?.uid
    let globalFunc = GlobalFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().titleTextAttributes = globalFunc.navTitle
        globalFunc.loadProfilePhoto(profileImage)

    }
    
    //Sets status bar content to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var messageBox: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    func sendMail() {
        if user == nil {
            //Alert if user is not signed in
            let alert = UIAlertController(title: "You must be signed in to send a message", message: "Please sign in or sign up for an account to send us a message.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
            
        else if user != nil {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["mmckinneyjr@gmail.com"])
                mail.setMessageBody(messageBox.text, isHTML: true)
                mail.setSubject("Legend's Moble User: \(user ?? "No ID")")
                
                present(mail, animated: true)
            }
            else {
                print("There was an error sending")
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func callButton(_ sender: Any) {
        guard let number = URL(string: "tel://" + "6087697596") else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func sendMessageButton(_ sender: Any) {
        sendMail()
    }
    
    //Dismisses keyboard if tap outside keyboard area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        messageBox.resignFirstResponder()
    }
    
}
