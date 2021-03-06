//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TweetCellDelegate, ComposeViewControllerDelegate {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    // weak var delegate: ComposeViewControllerDelegate?
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    

    override func viewWillAppear(_ animated: Bool) {
//            print ("it gets to view will disappear")
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            self.navigationController?.navigationBar.shadowImage = UIImage()
//            self.navigationController?.navigationBar.isTranslucent = false
//            self.navigationController?.view.backgroundColor = .clear
//            self.navigationController!.navigationBar.backgroundColor = UIColor(red: (247.0 / 255.0), green: (247.0 / 255.0), blue: (247.0 / 255.0), alpha: 1)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.white
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)

        
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        let imageView = UIImageView(frame: CGRect(x: 0, y:0, width: 50, height: 50))
        let image = UIImage(named: "TwitterLogoBlue.png")!
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {

        APIManager.shared.getHomeTimeLine { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                self.tweets = tweets
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    @IBAction func didTapPost(_ sender: Any) {
        performSegue(withIdentifier: "composeSegue", sender: self)
        
        
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
                APIManager.shared.getNewHomeTweets(with: Int(tweets.last!.id), completion: { (tweets: [Tweet]?, error: Error?) in
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
                        print ("there was not an error, but there are no new tweets")
                    }
                })
            }
        }
    }
    
    func didTapProfile(of user: User) {
        performSegue(withIdentifier: "timelineToProfile", sender: user)
        
    }
    
    func did(post: Tweet) {
        tweets.insert(post, at: 0)
        tableView.reloadData()
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "timelineToProfile" {
            let profileView = segue.destination as! ProfileViewController
            profileView.user = sender as! User
        } else if segue.identifier == "homeToDetail"{
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)!
            let tweet = tweets[indexPath.row]
            let view = segue.destination as! TweetDetailViewController
            view.tweet = tweet
        } else {
            let destination = segue.destination as! ComposeViewController
            destination.delegate = self
        }
     }
 
    
}
