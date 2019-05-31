//
//  UserDefs.swift
//  MessageApp
//
//  Created by abhinav khanduja on 31/05/19.
//  Copyright © 2019 abhinav khanduja. All rights reserved.
//

import Foundation

class UserDefs {
    
    static var setLogin : Bool = false {
        didSet {
            UserDefaults.standard.set(setLogin, forKey: "isLoggedIn")
        }
    }
    
    static var isLoggedIn : Bool {
        return (UserDefaults.standard.object(forKey: "isLoggedIn") != nil)
    }
    
    static var setEmail : String = "nil" {
        didSet {
            UserDefaults.standard.set(setEmail, forKey: "emailId")
        }
    }
    
    static var email : String {
        return UserDefaults.standard.object(forKey: "emailId") as! String
    }
    
    static var userDir : String {
        let userDirectoryName = UserDefs.email.components(separatedBy: ".com")
        let dir = userDirectoryName[0]
        return dir
    }
    
    static var setUsername : String = "nil" {
        didSet {
            UserDefaults.standard.set(setUsername, forKey: "username")
        }
    }
    
    static var username : String {
        return UserDefaults.standard.object(forKey: "username") as! String
    }
    
}
