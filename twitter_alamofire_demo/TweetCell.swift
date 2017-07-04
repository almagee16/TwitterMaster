//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            usernameLabel.text = tweet.user.screenname
            nameLabel.text = tweet.user.name
            dateLabel.text = tweet.createdAtString
            if tweet.retweetCount != 0 {
                retweetCountLabel.text = String(tweet.retweetCount)
            } else {
                retweetCountLabel.text = ""
            }
            
            if tweet.favoriteCount != 0 {
                favoriteCountLabel.text = String(tweet.favoriteCount!)
            } else {
                favoriteCountLabel.text = ""
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if retweetButton.isSelected {
            retweetButton.isSelected = false
            // retweet should be DECREMENTED
            tweet.retweetCount = tweet.retweetCount - 1
            if tweet.retweetCount != 0 {
                retweetCountLabel.text = String(tweet.retweetCount)
            } else {
                retweetCountLabel.text = ""
            }
            
        } else {
            retweetButton.isSelected = true
            // retweet should be INCREMENTED
            tweet.retweetCount = tweet.retweetCount + 1
            retweetCountLabel.text = String(tweet.retweetCount)
        }
    }
    
    
    @IBAction func onFavorite(_ sender: Any) {
        if favoriteButton.isSelected {
            favoriteButton.isSelected = false
            // favorite should be DECREMENTED
            tweet.favoriteCount = tweet.favoriteCount! - 1
            if tweet.favoriteCount != 0 {
                favoriteCountLabel.text = String(tweet.favoriteCount!)
            } else {
                favoriteCountLabel.text = ""
            }
            
        } else {
            favoriteButton.isSelected = true
            // favorite should be INCREMENTED
            tweet.favoriteCount = tweet.favoriteCount! + 1
            favoriteCountLabel.text = String(tweet.favoriteCount!)
            
        }
    }
    
    
    
    
    
}
