//
//  ComposeTweetVC.swift
//  MyTwitter
//
//  Created by Caroline Le on 3/6/17.
//  Copyright © 2017 The UNIQ. All rights reserved.
//

import UIKit
import AFNetworking

protocol ComposeTweetDelegate {
    func composeTweet (composeTweetVC: ComposeTweetVC, tweetText text: String)
}

class ComposeTweetVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var userImage: UIImageView!
  
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetCharactersCountLabel: UILabel!
    @IBOutlet weak var tweetComposeButton: UIButton!
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    var user: User!
    var delegate: ComposeTweetDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button
        tweetComposeButton.isEnabled = false
        
        // textView
        tweetTextView.becomeFirstResponder()
        tweetTextView.delegate = self
        
        // image
        userImage.setImageWith(User.currentUser!.profileUrl!)
        
    }

    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    
    @IBAction func onComposeTweet(_ sender: Any) {
        let text = tweetTextView.text
        delegate.composeTweet(composeTweetVC: self, tweetText: text!)
        dismiss(animated: true, completion: nil)
    }

    
    
// --- Countdown tweet characters limit
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let tweetCharacters = (tweetTextView?.text?.characters.count)! + (text.characters.count) - range.length
        
        if tweetCharacters == 0 {
            tweetComposeButton.isEnabled = false
            placeHolderLabel.isHidden = false
            
        } else if tweetCharacters > 0 {
            tweetComposeButton.isEnabled = true
            placeHolderLabel.isHidden = true
        }
        tweetCharactersCountLabel.text = "\(140 - tweetCharacters)"
        
        return tweetCharacters < 140
    }

    
}






