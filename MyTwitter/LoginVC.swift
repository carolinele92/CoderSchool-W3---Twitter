//
//  LoginVC.swift
//  MyTwitter
//
//  Created by Caroline Le on 3/1/17.
//  Copyright © 2017 The UNIQ. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func onLogin(_ sender: UIButton) {
        
        let client = TwitterClient.sharedInstance
        
        client?.login(success: {
            print ("I've logged in")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }, failure: { (error: Error) in
            print (error.localizedDescription)
            
        })
    }
    
}
