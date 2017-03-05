//
//  User.swift
//  MyTwitter
//
//  Created by Caroline Le on 3/4/17.
//  Copyright © 2017 The UNIQ. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenName: String?
    var tagline: String?
    var profileUrl: NSURL?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = NSURL(string: profileUrlString)
        }
        
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        // a block of code that run when sb tries to access this property
        get {
            if _currentUser == nil {
                // check if there is data inside "currentUserData"
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                // if there is,turn currentUserData back to the user JSON data and store it in currentUser & return currentUser
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }   
            }
            
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}

