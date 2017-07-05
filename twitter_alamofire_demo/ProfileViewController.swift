//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Alvin Magee on 7/4/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    var user: User?
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    var tweets: [Tweet] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if user == nil {
            user = User.current
        }
        
        APIManager.shared.getUserTimeLine(with: (user?.screenname)!) { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        profileImage.layer.cornerRadius = profileImage.frame.width * 0.5
        profileImage.layer.masksToBounds = true
        let url = URL(string: user!.profilePictureUrl)!
        profileImage.af_setImage(withURL: url)
        
        let backgroundURL = URL(string: user!.backgroundUrl)!
        backgroundImage.af_setImage(withURL: backgroundURL)
        
        nameLabel.text = user?.name
        screenNameLabel.text = user?.screenname
        followingCountLabel.text = String(user!.followingCount)
        followerCountLabel.text = String(user!.followerCount)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTweetCell", for: indexPath) as! UserTweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
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
