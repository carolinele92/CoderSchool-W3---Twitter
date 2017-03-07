//
//  TweetDetailsVC.swift
//  MyTwitter
//
//  Created by Caroline Le on 3/6/17.
//  Copyright © 2017 The UNIQ. All rights reserved.
//

import UIKit

class TweetDetailsVC: UIViewController {
    
    // User
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    // Retweet View
    @IBOutlet weak var retweetView: UIView!
    @IBOutlet weak var retweetUserLabel: UILabel!
    @IBOutlet weak var retweetViewHeightContraint: NSLayoutConstraint!
    
    // Counts
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    
    // Button
    @IBOutlet weak var replyButtonImage: UIButton!
    @IBOutlet weak var retweetButtonImage: UIButton!
    @IBOutlet weak var favoriteButtonImage: UIButton!
    
    var tweet: Tweet!
    var delegate: TweetCellDelegate!
    var tweetCell: TweetCell!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@\(tweet.user!.screenName!)"
            tweetTextLabel.text = tweet.text
            timestampLabel.text = tweet.longTimestamp
            profileImage.setImageWith((tweet.user?.profileUrl)!)
        
            
            // Retweet ???
            if tweet.isRetweet! {
                self.retweetViewHeightContraint.constant = 20
                retweetView.isHidden = false
                retweetUserLabel.text = "\(tweet.retweetUsername!) Retweeted"
            } else {
                self.retweetViewHeightContraint.constant = 0
                retweetView.isHidden = true
            }
        
            retweetButton()
            favoriteButton()
    }


    @IBAction func onRetweet(_ sender: Any) {
        retweetButton()
        delegate.onRetweet(tweetCell: tweetCell)
    }
    
    
    
    @IBAction func onFavorite(_ sender: Any) {
        favoriteButton()
        delegate.onFavorite(tweetCell: tweetCell)
        
    }

    
 
    
    // Retweeted
    func retweetButton () {
        if tweet.isRetweeted {
            retweetButtonImage.imageView?.image = UIImage(named: "retweet_colored")
        } else {
            retweetButtonImage.imageView?.image = UIImage(named: "retweet")
        }
        
        
        if  tweet.retweetCount == 0 {
            retweetsCountLabel.isHidden = true
        } else {
            retweetsCountLabel.isHidden = false
            retweetsCountLabel.text = String(describing: tweet.retweetCount)
        }
    }
    
    
    
    // Favorited
    func favoriteButton () {
        if  tweet.isFavorited {
            favoriteButtonImage.imageView?.image = UIImage(named: "favorite_colored")
        } else {
            favoriteButtonImage.imageView?.image = UIImage(named: "favorite")
        }
        
        
        if  tweet.favoritesCount == 0 {
            favoritesCountLabel.isHidden = true
        } else {
            favoritesCountLabel.isHidden = false
            favoritesCountLabel.text = String(describing: tweet.favoritesCount)
        }

    }
    

}











