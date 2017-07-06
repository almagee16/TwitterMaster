//
//  MentionsViewController.swift
//  twitter_alamofire_demo
//
//  Created by Alvin Magee on 7/4/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TweetCellDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet] = []
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    let refreshControl = UIRefreshControl()

    override func viewWillAppear(_ animated: Bool) {
            print ("it gets to view will disappear")
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.view.backgroundColor = .clear
            self.navigationController!.navigationBar.backgroundColor = UIColor(red: (247.0 / 255.0), green: (247.0 / 255.0), blue: (247.0 / 255.0), alpha: 1)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false

        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        APIManager.shared.getMentionsTimeLine { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionsTweetCell", for: indexPath) as! MentionsTweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        APIManager.shared.getMentionsTimeLine { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                self.tweets = tweets
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            } else if let error = error {
                print ("Error getting Mentions timeline: " + error.localizedDescription)
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
                APIManager.shared.getNewMentionsTweets(with: Int(tweets.last!.id), completion: { (tweets: [Tweet]?, error: Error?) in
                    if let error = error {
                        print (error.localizedDescription)
                    } else if let tweets = tweets {
                        print ("success")
                        self.isMoreDataLoading = false
                        self.loadingMoreView!.stopAnimating()
                        if tweets.count == 1 {
                            
                        } else {
                            for tweet in tweets {
                                self.tweets.append(tweet)
                            }
                            self.tableView.reloadData()
                        }
                        
                    } else {
                        print ("there was no error, but there are no new tweets")
                    }
                })
                
                
            }
        }
    }
    
    func didTapProfile(of user: User) {
        performSegue(withIdentifier: "mentionsToProfile", sender: user)
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "mentionsToProfile" {
            let profileView = segue.destination as! ProfileViewController
            profileView.user = sender as! User
            print ("tester after this")
        } else if segue.identifier == "mentionsToDetail" {
            let cell = sender as! MentionsTweetCell
            let indexPath = tableView.indexPath(for: cell)!
            let tweet = tweets[indexPath.row]
            let view = segue.destination as! TweetDetailViewController
            view.tweet = tweet
        }
    }
 

}
