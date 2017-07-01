//
//  TweetsViewController.swift
//  TwitterClientWK3
//
//  Created by Phạm Thanh Hùng on 7/1/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl?
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        
    }
    
    func fetchTweets() {
        TwitterClient.sharedInstance?.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            if (self.refreshControl != nil) {
                self.refreshControl!.endRefreshing()
            }
        }, failure: nil)
    }
    
    func refreshControlAction() {
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.insertSubview(refreshControl!, at: 0)
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

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = tweets?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        let tweet = tweets![indexPath.row]
        
        cell.tweetLabel.text = tweet.tweet
        
        if let timestamp = tweet.time {
            cell.timeLabel.text = tweet.timeAgoSince(timestamp)
        }
        
        cell.usernameLabel.text = tweet.user?.name
        
        cell.profileImageView.setImageWith((tweet.user?.profileUrl)!, placeholderImage: nil)
        
        return cell
    }
}
