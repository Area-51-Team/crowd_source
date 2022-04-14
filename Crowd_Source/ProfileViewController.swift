//
//  ProfileViewController.swift
//  Crowd_Source
//
//  Created by Kyle Louderback on 4/14/22.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    
    let user = PFUser.current()
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    
    @IBOutlet weak var profileEmailField: UITextField!
    @IBOutlet weak var profileNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileNameField.delegate = self
        profileEmailField.delegate = self
        atLoad()
//        profileName.text = user?.name
        profileEmail.text = user?.email
        
        let user = PFUser.current()!
        user["name"] = profileName.text
    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
        saveBtn.isHidden = true
        profileNameField.isHidden = true
        profileName.isHidden = false
        profileName.text = profileNameField.text
        profileEmailField.isHidden = true
        profileEmail.text = profileEmailField.text
        profileEmail.isHidden = false
        
        let currentUser = PFUser.current()
        currentUser!["email"] = profileEmail.text
        currentUser!["name"] = profileName.text
        
        currentUser!.saveInBackground()
        
        
    }
    @objc func nameTapped(){
        profileNameField.text = profileName.text
        profileEmailField.text = profileEmail.text
        profileName.isHidden = true
        profileNameField.isHidden = false
        profileNameField.text = profileName.text
        saveBtn.isHidden = false
    }
    @objc func emailTapped(){
        profileEmailField.text = profileEmail.text
        profileNameField.text = profileName.text
        profileEmail.isHidden = true
        profileEmailField.isHidden = false
        profileEmailField.text = profileEmail.text
        saveBtn.isHidden = false
    }
    
    //    func textFieldShouldReturn(userText: UITextField) -> Bool {
    //        userText.resignFirstResponder()
    //        profileNameField.isHidden = true
    //        profileName.isHidden = false
    //        profileName.text = profileNameField.text
    //        profileEmailField.isHidden = true
    //        profileEmail.isHidden = false
    //        profileEmail.text = profileEmailField.text
    //        return true
    //    }
    
    func atLoad(){
        profileNameField.isHidden = true
        if user?.email != nil{
            profileEmailField.isHidden = true
        }else{
            profileEmailField.isHidden = false
        }
        
        saveBtn.isHidden = true
        let aSelector : Selector = #selector(self.nameTapped)
        let bSelector : Selector = #selector(self.emailTapped)
        let nameTapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        nameTapGesture.numberOfTapsRequired = 1
        profileName.addGestureRecognizer(nameTapGesture)
        let emailTapGesture = UITapGestureRecognizer(target: self, action: bSelector)
        emailTapGesture.numberOfTapsRequired = 1
        profileEmail.addGestureRecognizer(emailTapGesture)
        profileName.isUserInteractionEnabled = true
        profileEmail.isUserInteractionEnabled = true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}



