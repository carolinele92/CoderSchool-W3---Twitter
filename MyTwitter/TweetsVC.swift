//
//  TweetsVC.swift
//  MyTwitter
//
//  Created by Caroline Le on 3/4/17.
//  Copyright © 2017 The UNIQ. All rights reserved.
//

import UIKit

class TweetsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        
        getTweets()

    }


    func getTweets() {
        TwitterClient.sharedInstance?.getHomeTimeline(success: { (tweets: [Tweet]) in
            
            self.tweets = tweets
            
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print (error.localizedDescription)
        })
    }
    
    
    
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
    }

}

extension TweetsVC: UITableViewDelegate, UITableViewDataSource, TweetCellDelegate, ComposeTweetDelegate {

    
// --- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetCell
        cell.delegate = self
        
        if tweets != nil {
            cell.tweet = tweets[indexPath.row]
        }
        
        
        return cell
    }
    
    
    
    
// --- TweetCellDelegate
    
    func onRetweet(tweetCell: TweetCell!) {
        // when called from API, if the post is already retweeted, when retweet button is clicked, we unretweet
        if tweetCell.tweet.isRetweeted {
            TwitterClient.sharedInstance?.unRetweet(tweet: tweetCell.tweet.id, success: {
                
                tweetCell.tweet.retweetCount = tweetCell.tweet.retweetCount - 1
                tweetCell.retweetCountLabel.text = String(describing: tweetCell.tweet.retweetCount)
                tweetCell.tweet.isRetweeted = false
                
                self.tableView.reloadData()
                
            }, failure: { (error: Error) in
                print ("Error with unretweet")
            })
            
        } else {
            TwitterClient.sharedInstance?.retweet(tweet: tweetCell.tweet.id , success: {
                
                tweetCell.tweet.retweetCount = tweetCell.tweet.retweetCount + 1
                tweetCell.retweetCountLabel.text = String(describing: tweetCell.tweet.retweetCount)
                tweetCell.tweet.isRetweeted = true
                
                self.tableView.reloadData()
                
            }, failure: { (error: Error) in
                print("Error with retweet")
            })
        }
    }

    
    
    func onFavorite(tweetCell: TweetCell!) {
        
        let tweet = tweetCell.tweet!
        
        if tweet.isFavorited {
            TwitterClient.sharedInstance?.unFavorite(tweet: tweet.id, success: {
                
                tweet.favoritesCount = tweet.favoritesCount - 1
                tweetCell.favoriteCountLabel.text = String(describing: tweet.favoritesCount)
                tweet.isFavorited = false
                
                self.tableView.reloadData()
                
            }, failure: { (error: Error) in
                print("Error with unfavorite")
            })
            
        } else {
            TwitterClient.sharedInstance?.favorite(tweet: tweet.id, success: {
                
                tweet.favoritesCount = tweet.favoritesCount + 1
                tweetCell.favoriteCountLabel.text = String(describing: tweet.favoritesCount)
                tweet.isFavorited = true
                self.tableView.reloadData()
                
            }, failure: { (error: Error) in
                print("Error with favorite")
            })
        }
    }
    

// --- Compose Tweet
    
    func composeTweet(composeTweetVC: ComposeTweetVC, tweetText text: String) {
        let path = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        TwitterClient.sharedInstance?.composeTweet(tweet: path!, success: { (tweet: Tweet) in
            self.tweets.insert(tweet, at: 0)
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print ("Error with composing tweet \(error)")
        })
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "composeTweetSegue" {
            let vc = segue.destination as! ComposeTweetVC
            vc.delegate = self
        }
    
    }
    
    
}












