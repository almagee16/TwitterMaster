//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import TTTAttributedLabel

protocol TweetCellDelegate {
    func didTapReply()
}

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
    
    // weak var delegate: TweetCellDelegate!
    
    
    
    var tweet: Tweet! {
        didSet {
            if tweet.favorited! {
                favoriteButton.isSelected = true
            } else {
                favoriteButton.isSelected = false
            }
            
            if tweet.retweeted {
                retweetButton.isSelected = true
            } else {
                retweetButton.isSelected = false

            }
            
            tweetTextLabel.text = tweet.text
            usernameLabel.text = tweet.user.screenname
            nameLabel.text = tweet.user.name
            dateLabel.text = tweet.createdAtString
            
            if tweet.retweetCount != 0 {
                if tweet.retweetCount >= 1000000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000000) + "M"
                }
                if tweet.retweetCount >= 1000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000) + "K"
                } else {
                    retweetCountLabel.text = String(tweet.retweetCount)
                }
            } else {
                retweetCountLabel.text = ""
            }
            
            if tweet.favoriteCount != 0 {
                if tweet.favoriteCount! >= 1000000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000000) + "M"
                } else if tweet.favoriteCount! >= 1000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000) + "K"
                } else {
                    favoriteCountLabel.text = String(tweet.favoriteCount!)
                }
            } else {
                favoriteCountLabel.text = ""
            }
            
            profileImage.layer.cornerRadius = profileImage.frame.width * 0.1
            profileImage.layer.masksToBounds = true
            
            let url = URL(string: tweet.user.profilePictureUrl)!
            profileImage.af_setImage(withURL: url)
            
            
            
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
                if tweet.retweetCount >= 1000000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000000) + "M"
                }
                if tweet.retweetCount >= 1000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000) + "K"
                } else {
                    retweetCountLabel.text = String(tweet.retweetCount)
                }
            } else {
                retweetCountLabel.text = ""
            }
            
            APIManager.shared.unRetweet(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print (error.localizedDescription)
                } else {
                    print ("successfully unretweeted")
                }
            })
            
        } else {
            retweetButton.isSelected = true
            // retweet should be INCREMENTED
            tweet.retweetCount = tweet.retweetCount + 1
            if tweet.retweetCount != 0 {
                if tweet.retweetCount >= 1000000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000000) + "M"
                }
                if tweet.retweetCount >= 1000 {
                    retweetCountLabel.text = String(tweet.retweetCount / 1000) + "K"
                } else {
                    retweetCountLabel.text = String(tweet.retweetCount)
                }
            } else {
                retweetCountLabel.text = ""
            }
            
            APIManager.shared.retweet(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print (error.localizedDescription)
                } else if let tweet = tweet {
                    print ("successfully retweeted")
                }
            })
            
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
            if tweet.favoriteCount != 0 {
                if tweet.favoriteCount! >= 1000000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000000) + "M"
                } else if tweet.favoriteCount! >= 1000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000) + "K"
                } else {
                    favoriteCountLabel.text = String(tweet.favoriteCount!)
                }
            } else {
                favoriteCountLabel.text = ""
            }
            
            APIManager.shared.unFavorite(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print (error.localizedDescription)
                } else {
                    print ("successfully unfavorited the tweet")
                }
            })
            
        } else {
            favoriteButton.isSelected = true
            // favorite should be INCREMENTED
            tweet.favoriteCount = tweet.favoriteCount! + 1
            favoriteCountLabel.text = String(tweet.favoriteCount!)
            if tweet.favoriteCount != 0 {
                if tweet.favoriteCount! >= 1000000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000000) + "M"
                } else if tweet.favoriteCount! >= 1000 {
                    favoriteCountLabel.text = String(tweet.favoriteCount! / 1000) + "K"
                } else {
                    favoriteCountLabel.text = String(tweet.favoriteCount!)
                }
            } else {
                favoriteCountLabel.text = ""
            }
            
            
            APIManager.shared.favorite(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print ("right before here")
                    print (error.localizedDescription)
                } else if let tweet = tweet {
                    print ("successfully favorited the tweet")
                }
            })
            
        }
    }
    
    
    
    
    
}
