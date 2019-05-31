//
//  LogInPageViewController.swift
//  MessageApp
//
//  Created by abhinav khanduja on 12/09/18.
//  Copyright © 2018 abhinav khanduja. All rights reserved.
//

import UIKit
import Firebase

class LogInPageViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var errorLabel: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var enteredEmail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logRegBtn: UIButton!
    @IBOutlet weak var btnBlurBg: UIVisualEffectView!
    
    var height : CGFloat = 0
    
    @IBOutlet weak var loginIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        errorLabel.layer.cornerRadius = 6
        errorLabel.layer.masksToBounds = true
        ref = Database.database().reference()
        username.isHidden = true
        height = loginIconTopConstraint.constant
        btnBlurBg.layer.cornerRadius = btnBlurBg.frame.height/2
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.loginIconTopConstraint.constant = -60
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.loginIconTopConstraint.constant = self.height
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    @IBAction func logRegBtnTapped(_ sender: Any) {
        if logRegBtn.titleLabel?.text == "Log In" {
            logIn()
        }else {
            register()
        }
    }
    
    @IBAction func segmentCtrl(_ sender: CustomSegmentControl) {
        if sender.selectedSegmentTitle == "Register" {
            username.isHidden = false
            logRegBtn.setTitle("Register", for: .normal)
        }else {
            username.isHidden = true
            logRegBtn.setTitle("Log In", for: .normal)
        }
    }
    
    func logIn() {
        guard let usrEmail = enteredEmail.text else { return }
        guard let password = password.text else { return }
        
        Auth.auth().signIn(withEmail: usrEmail, password: password) { (user, error) in
            if error != nil {
                self.displayError(error: error!)
                UserDefs.setLogin = false
            }else {
                UserDefs.setEmail = usrEmail
                
                UserDefs.setLogin = true
                
                self.performSegue(withIdentifier: "friendList", sender: self)
            }
        }
    }
    
    func register() {
        guard let usrEmail = enteredEmail.text else { return }
        guard let password = password.text else { return }
        
        Auth.auth().createUser(withEmail: usrEmail, password: password) { (authResult, error) in
            if error != nil {
                self.displayError(error: error!)
                UserDefs.setLogin = false
            }else {
                UserDefs.setEmail = usrEmail
                
                self.getUsrDetails()
                
                UserDefs.setLogin = true
    
                self.createDatabase()
                self.performSegue(withIdentifier: "friendList", sender: self)
            }
        }
    }
    
    func createDatabase() {
        let userDirectoryName = enteredEmail.text?.components(separatedBy: ".com")
        UserDefaults.standard.set("\(userDirectoryName![0])", forKey: "userDir")
        let dictionary : [String:Any] = ["username":username.text!,"email_id": enteredEmail.text!]
        self.ref.child("users").child("\(userDirectoryName![0])").setValue(dictionary)
    }
    
    func getUsrDetails() {
        let userDirectoryName = enteredEmail.text?.components(separatedBy: ".com")
        refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            let dir = postDict["users"] as? [String : AnyObject]
            
            let usrDir = dir!["\(userDirectoryName![0])"] as? [String:AnyObject]
            
            UserDefs.setUsername = usrDir?["username"] as! String
        })
    }
    
    func displayError(error: Error) {
        let errorTxt = error.localizedDescription.components(separatedBy: ".")
        self.errorLabel.text = errorTxt[0]
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.errorLabel.alpha = 1
        }) { (completion) in
            if completion {
                UIView.animate(withDuration: 1, delay: 2, options: .curveEaseOut, animations: { [weak self] in
                    self?.errorLabel.alpha = 0
                }, completion: nil)
            }
        }
    }
}
