//
//  Tweet.swift
//  MyTwitter
//
//  Created by Caroline Le on 3/4/17.
//  Copyright © 2017 The UNIQ. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var retweetCount: Int?
    var favoritesCount: Int?
    var timestamp: Date?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
    }


    class func tweetsWithArray (dictionaries: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }

}
