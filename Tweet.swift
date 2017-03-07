//
//  Tweet.swift
//  MyTwitter
//
//  Created by Caroline Le on 3/4/17.
//  Copyright © 2017 The UNIQ. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
        // tweet
    var user: User?
    var text: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var shortTimestamp: String?
    var longTimestamp: String?
    
        // retweet
    var isRetweet: Bool?
    var retweetUsername: String?
    var id: Int = 0
    
        // action buttons
    var isFavorited: Bool
    var isRetweeted: Bool
    
    
    init(dictionary: NSDictionary) {
        
        // Retweet
        if (dictionary["retweeted_status"] != nil) {
            self.isRetweet = true
            
            let retweetedStatusDictionary = dictionary["retweeted_status"] as! NSDictionary
            user = User(dictionary: retweetedStatusDictionary["user"] as! NSDictionary)
            text = retweetedStatusDictionary["text"] as? String
            retweetCount = (retweetedStatusDictionary["retweet_count"] as? Int) ?? 0
            favoritesCount = (retweetedStatusDictionary["favorite_count"] as? Int) ?? 0
            id = retweetedStatusDictionary["id"] as! Int
            
            let retweetUser = dictionary["user"] as! NSDictionary
            retweetUsername = retweetUser["name"] as? String  
            
           
        // No retweet
        } else {
            self.isRetweet = false
            
            user = User(dictionary: dictionary["user"] as! NSDictionary)
            text = dictionary["text"] as? String
            retweetUsername = nil
            retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
            favoritesCount = (dictionary["favourite_count"] as? Int) ?? 0
            id = dictionary["id"] as! Int
           
        }
        
        // action buttons
            isFavorited = dictionary["favorited"] as! Bool
            isRetweeted = dictionary["retweeted"] as! Bool
        
     
        // timestamp
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            // Short Timestamp
            let formattedTimestamp = formatter.date(from: timestampString)! // change string to date
            shortTimestamp = Tweet.formatTweetTimeStamp((formattedTimestamp.timeIntervalSinceNow))
            
            // Long timestamp
            formatter.dateFormat = "M/d/yy, HH:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            longTimestamp = formatter.string(from: formattedTimestamp)
        }
        
    }
    
    
    // Tweets Array
    class func tweetsWithArray (dictionaries: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }

    
    // Short timestamp - Time interval since now
    class func formatTweetTimeStamp(_ timeStamp: TimeInterval) -> String{
        var time = Int(timeStamp)
        var timeSinceTweet: Int = 0
        var timeLabel = ""

        time = time * -1
        
        
        if time < 60 {                          //Seconds ago
            timeSinceTweet = time
            timeLabel = "s"
        } else if ((time/60) <= 60) {           //Minutes ago
            timeSinceTweet = time / 60
            timeLabel = "m"
        } else if ((time/60/60) <= 24) {         //Hours ago
            timeSinceTweet = time/60/60
            timeLabel = "h"
        } else if ((time/60/60/24) <= 365) {      //Days ago
            timeSinceTweet = time/60/60/24
            timeLabel = "d"
        } else if ((time/60/60/24/365) <= 1) {    //Years ago
            timeSinceTweet = time/60/60/24/365
            timeLabel = "y"
        }
        
        return ("\(timeSinceTweet)\(timeLabel)")
    }
    
    
}
