//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Alvin Magee on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.lightGray
        nameLabel.text = tweet.user.name
        usernameLabel.text = tweet.user.screenname
        tweetTextLabel.text = tweet.text
        dateLabel.text = tweet.createdAtString
        retweetCountLabel.text = String(tweet.retweetCount)
        favoriteCountLabel.text = String(tweet.favoriteCount!)
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
