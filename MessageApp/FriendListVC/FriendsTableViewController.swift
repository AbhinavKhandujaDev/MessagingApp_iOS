//
//  FriendsTableViewController.swift
//  MessageApp
//
//  Created by abhinav khanduja on 14/09/18.
//  Copyright © 2018 abhinav khanduja. All rights reserved.
//

import UIKit
import Firebase

struct FrndListCell {
    let email: String
//    let lastChat: String
}

class FriendsTableViewController: UITableViewController {

    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    var friendList = [FrndListCell]()
    
    var chatsNavTitleName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getUsrDetails()
        navigationController?.view.backgroundColor = .clear
        tableView.backgroundView = UIImageView(image: UIImage?(#imageLiteral(resourceName: "friendListBg")), highlightedImage: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! FriendsTableViewCell

        cell.frndEmail.text = friendList[indexPath.row].email
        //cell.lastChatMessage.text = friendList[indexPath.row].lastChat

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatsNavTitleName = friendList[indexPath.row].email
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatsViewController") as! ChatsViewController
        vc.navTitle = chatsNavTitleName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInPageViewController") as! LogInPageViewController
        self.navigationController!.pushViewController(vc, animated: true)
        self.navigationController?.isNavigationBarHidden = true
        UserDefs.setLogin = false
        
        UserDefs.setEmail = "nil"

        UserDefs.setUsername = "nil"
    }
    
    func getUsrDetails() {
        refHandle = ref.queryOrderedByPriority().observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            let dir = postDict[UserDefs.userDir] as? [String : AnyObject]
            let messages = dir!["messages"] as? [String : AnyObject]
            
            print(messages)
            for (key,value) in postDict {
                
                if key == UserDefs.userDir || self.friendList.contains(where: {$0.email == key}) {
                    continue
                }else {
                    self.friendList.insert(FrndListCell(email: (value["email_id"] as? String)!), at: 0)
                }
            }
            self.tableView.reloadData()
        })
    }
}

extension String {
    
}
