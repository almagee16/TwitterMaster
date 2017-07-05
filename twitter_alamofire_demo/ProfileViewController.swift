//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Alvin Magee on 7/4/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    var user: User?
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    var tweets: [Tweet] = []
    @IBOutlet weak var tableView: UITableView!
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    let refreshControl = UIRefreshControl()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if user == nil {
            user = User.current
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
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
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        
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
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        APIManager.shared.getUserTimeLine(with: (user?.screenname)!) { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                self.tweets = tweets
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting user timeline: " + error.localizedDescription)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                APIManager.shared.getNewUserTweets(with: (user!.screenname), id: Int(tweets.last!.id), completion: { (tweets: [Tweet]?, error: Error?) in
                    if let error = error {
                        print (error.localizedDescription)
                    } else if let tweets = tweets {
                        print ("success")
                        self.isMoreDataLoading = false
                        self.loadingMoreView!.stopAnimating()
                        for tweet in tweets {
                            self.tweets.append(tweet)
                        }
                        self.tableView.reloadData()
                    } else {
                        print ("there was no error, but there are no new tweets")
                    }
                })
                

            }
        }
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
