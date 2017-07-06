//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Alvin Magee on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import ActiveLabel


class TweetDetailViewController: UIViewController, TweetCellDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    var tweet: Tweet!
    weak var delegate: TweetCellDelegate?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = tweet.user.name
        usernameLabel.text = tweet.user.screenname
        
        tweetTextLabel.enabledTypes = [.mention, .hashtag, .url]
        tweetTextLabel.text = tweet.text
        tweetTextLabel.handleURLTap { (url) in
            UIApplication.shared.openURL(url)
        }
        tweetTextLabel.text = tweet.text
        
        delegate = self
        
        dateLabel.text = tweet.detailDateString 
        
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
            retweetCountLabel.text = "0"
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
            favoriteCountLabel.text = "0"
        }
        
        if tweet.favorited! {
            favoriteButton.isSelected = true
        }
        
        if tweet.retweeted {
            retweetButton.isSelected = true 
        }
        
        profileImage.layer.cornerRadius = profileImage.frame.width * 0.5
        profileImage.layer.masksToBounds = true
        
        let url = URL(string: tweet.user.profilePictureUrl)!
        profileImage.af_setImage(withURL: url)

        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapProfile(_ sender: Any) {
        print ("it got to the tap")
        delegate?.didTapProfile(of: tweet.user)
    }
    
    func didTapProfile(of user: User) {
        print ("now it's at the delegate method")
        performSegue(withIdentifier: "detailToProfile", sender: user)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let profileViewController = segue.destination as! ProfileViewController
        profileViewController.user = sender as! User
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if retweetButton.isSelected {
            retweetButton.isSelected = false
            // retweet should be DECREMENTED
            tweet.retweeted = false
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
            tweet.retweeted = true
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
            tweet.favorited = false
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
            tweet.favorited = true
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
