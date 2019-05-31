//
//  ChatsViewController.swift
//  MessageApp
//
//  Created by abhinav khanduja on 13/09/18.
//  Copyright © 2018 abhinav khanduja. All rights reserved.
//

import UIKit
import Firebase

struct Message {
    let message : String?
    let sender : String?
    let time : Date?
}

class ChatsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var messages = [Message]()
 
    var txtFieldIsEditing = false
    
    var frndUsrDir : [String]?
    
    var boardHeight : CGFloat = 0
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    let date1 = Date()
    let date2 = Date()
    
    var navTitle : String!
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        messages.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frndUsrDir = navTitle.components(separatedBy: ".com")
        
        configTableView()
        
        self.navigationItem.title = navTitle
        
        ref = Database.database().reference()
        
        getMessages()
        
        messageTableView.register(UINib(nibName: "CustomChatsTableViewCell", bundle: nil), forCellReuseIdentifier: "chatsIdentifier")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Visible cells are: ",messageTableView.visibleCells.count)
        print("Visible cells are 2: ",(messageTableView.frame.height / 125 ) + 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        txtField.layer.cornerRadius = txtField.frame.height/2
        txtField.layer.masksToBounds = true
        
        sendBtn.layer.cornerRadius = sendBtn.frame.height/5
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
        messageTableView.addGestureRecognizer(gesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if txtFieldIsEditing == true {
            resignKeyboard()
        }else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usrBubbleCell = tableView.dequeueReusableCell(withIdentifier: "chatsIdentifier", for: indexPath) as! CustomChatsTableViewCell
        
        let senderBubbleCell = tableView.dequeueReusableCell(withIdentifier: "senderChatsIdentifier", for: indexPath) as! SenderTableViewCell
        
        usrBubbleCell.selectionStyle = .none
        senderBubbleCell.selectionStyle = .none
        
        if (messages[indexPath.row].sender == UserDefs.email) {
            usrBubbleCell.msgLbl.text = messages[indexPath.row].message
            return usrBubbleCell
        }else {
            senderBubbleCell.senderBubbleLbl.text = messages[indexPath.row].message
            return senderBubbleCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignKeyboard()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            boardHeight = keyboardHeight
            //self.msgTbleViewConstraint.constant = boardHeight
            viewHeightConstraint.constant = boardHeight
            view.layoutIfNeeded()
            scrollToBottom()
            txtFieldIsEditing = true
        }
    }
    
    func configTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 125.00
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        
        if (txtField.text?.isEmpty)! {
            return
        }else {
            
            let date = Date()
            
            let sendToDict : [String:Any] = ["sender":UserDefs.email, "message":txtField.text!, "time": "\(date)"]
            let sentFromDict : [String:Any] = ["sender":UserDefs.email, "message":txtField.text!, "time": "\(date)"]
            
            let lastMsg : [String:Any] = ["sent_by":UserDefs.email, "last_message":txtField.text!, "time_sent": "\(date)"]
            
            //Sent to
            ref.child("users").child("\(frndUsrDir![0])").child("messages").child("\(String(describing: UserDefs.email))").childByAutoId().setValue(sendToDict)
            ref.child("users").child("\(frndUsrDir![0])").child("messages").child("\(String(describing: UserDefs.email))").child("last_chat").setValue(lastMsg)
            
            //Sent from
            ref.child("users").child("\(String(describing: UserDefs.email))").child("messages").child("\(frndUsrDir![0])").childByAutoId().setValue(sentFromDict)
            ref.child("users").child("\(String(describing: UserDefs.email))").child("messages").child("\(frndUsrDir![0])").child("last_chat").setValue(lastMsg)
        }
        txtField.text = nil
    }
    
    func getMessages() {
        refHandle = ref.child("users").child("\(UserDefs.userDir)").child("messages").child(frndUsrDir![0]).queryOrderedByKey().observe(.childAdded) { (snapshot) in
            let post = snapshot.value as? [String: String]
            
            let dirMsg = post!["message"]
            let sender = post!["sender"]
            let time   = post?["time"]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZZ"
            let date = dateFormatter.date(from: (time) ?? "nil")
            
            if dirMsg != nil {
                self.messages.append(Message(message: dirMsg, sender: sender, time: date))
                self.messageTableView.reloadData()
                self.scrollToBottom()
            }else {
                return
            }
        }
    }
    
    @objc func resignKeyboard() {
        if txtFieldIsEditing == true {
            view.endEditing(true)
            resignFirstResponder()
            UIView.animate(withDuration: 0.26) {
                self.viewHeightConstraint.constant -= self.boardHeight
                self.view.layoutIfNeeded()
            }
            txtFieldIsEditing = false
        }else {
            return
        }
    }
    
    func scrollToBottom() {
        if messages.isEmpty {
            return
        }else {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
}
