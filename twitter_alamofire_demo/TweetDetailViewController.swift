//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Alvin Magee on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, TweetCellDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
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
        
        profileImage.layer.cornerRadius = profileImage.frame.width * 0.1
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
    

}
