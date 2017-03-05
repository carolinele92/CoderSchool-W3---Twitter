//
//  TwitterClient.swift
//  MyTwitter
//
//  Created by Caroline Le on 3/4/17.
//  Copyright © 2017 The UNIQ. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com/")! as URL!, consumerKey: "9HpBlkBcXxkUaiMoBaPIR9iRT", consumerSecret: "G10JWAW76P3FCUdnFlJDHdVG2piFjPGA3QlTi8mJHvbfkwMXSN")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    
    
// --- Login
    func login (success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        // Step 1: Get Request Token (oauth_oken)
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: "caroline92Twitter://"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            if let requestToken = requestToken {
                print ("request token = \(requestToken.token)")
                
                // Step 2: Redirecting the user after getting request token
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")
                
                // to switch out of ur app
                UIApplication.shared.open(authURL!, options: [:], completionHandler: nil )
            }
            
        }, failure: { (error: Error?) in
            print ("\(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }


// --- Open url
    func handleOpenUrl (url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print (url)
            
            // Get the User -> currentUser
            self.getCurentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }, failure: { (error: Error?) in
            print ("\(error?.localizedDescription)")
            self.loginFailure?(error!)
            
        })

    }
    
    
    
// --- Fetch User account
    func getCurentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
    
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
    
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
    
            success(user)  //if success returns user
            
            print ("name = \(user.name)")
    
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)  //if failure returns error
        })
    
    }
    

// --- Fetch Home timeline
    func getHomeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
       get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //print ("home timeline \(response)")
            
            let tweetDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetDictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        })
    }
   
}
