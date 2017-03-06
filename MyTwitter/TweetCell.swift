//
//  TweetCell.swift
//  MyTwitter
//
//  Created by Caroline Le on 3/5/17.
//  Copyright © 2017 The UNIQ. All rights reserved.
//

import UIKit
import AFNetworking

protocol TweetCellDelegate: class {
    func onRetweet (tweetCell: TweetCell!)
    func onFavorite (tweetCell: TweetCell!)
}


class TweetCell: UITableViewCell {

    // User's profile
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    // Button
    @IBOutlet weak var replyButtonImage: UIButton!
    @IBOutlet weak var retweetButtonImage: UIButton!
    @IBOutlet weak var favoritesButtonImage: UIButton!
    
    
    // Counts
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    // Retweet
    @IBOutlet weak var retweetView: UIView!
    @IBOutlet weak var retweetUserLabel: UILabel!
    
    
    // Constraint
    @IBOutlet weak var retweetViewHeightContraint: NSLayoutConstraint!
    
    var delegate: TweetCellDelegate!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            screennameLabel.text = "@\(tweet.user!.screenName!)"
            tweetTextLabel.text = tweet.text
            timestampLabel.text = tweet.timestamp
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
            
            
            // Favorited
            if tweet.isFavorited {
                favoritesButtonImage.imageView?.image = UIImage(named: "favorite_colored")
            } else {
                favoritesButtonImage.imageView?.image = UIImage(named: "favorite")
            }
            
            
            if tweet.favoritesCount == 0 {
                favoriteCountLabel.isHidden = true
            } else {
                favoriteCountLabel.isHidden = false
                favoriteCountLabel.text = String(describing: tweet.favoritesCount)
            }

            
            // Retweeted 
            if tweet.isRetweeted {
                retweetButtonImage.imageView?.image = UIImage(named: "retweet_colored")
            } else {
                retweetButtonImage.imageView?.image = UIImage(named: "retweet")
            }
            
            
            if tweet.retweetCount == 0 {
                retweetCountLabel.isHidden = true
            } else {
                retweetCountLabel.isHidden = false
                retweetCountLabel.text = String(describing: tweet.retweetCount)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    @IBAction func onRetweet(_ sender: Any) {
        delegate.onRetweet(tweetCell: self)
        
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        delegate.onFavorite(tweetCell: self)
    }
    
    
   
    



}






