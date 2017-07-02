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
        refreshControl!.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!)
        
        fetchTweets()
    }
    
    func fetchTweets() {
        TwitterClient.sharedInstance?.getHomeTimeline(success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.getHomeTimeline(success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.insertSubview(refreshControl!, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignOutTapped(_ sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
    
    @IBAction func onRetweet(_ sender: UIButton) {
        let button = sender
        let view = button.superview!
        let cell = view.superview as! TweetCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets![indexPath!.row]
        let path = tweet.id
        let retweeted = tweet.retweeted
        
        if retweeted == false {
            TwitterClient.sharedInstance?.retweet(id: path!, params: nil) { (error) -> () in
                print("Retweeting")
                self.tweets![indexPath!.row].retweetCount = self.tweets![indexPath!.row].retweetCount! + 1
                tweet.retweeted = true
                cell.retweetButton.setImage(UIImage(named: "retweet_on"), for: UIControlState())
                self.tableView.reloadData()
            }
        } else if retweeted ==  true {
            TwitterClient.sharedInstance?.unretweet(id: path!, params: nil , completion: { (error) -> () in
                print("Unretweeting")
                self.tweets![indexPath!.row].retweetCount  = self.tweets![indexPath!.row].retweetCount! - 1
                tweet.retweeted = false
                cell.retweetButton.setImage(UIImage(named: "retweet_off"), for: UIControlState())
                self.tableView.reloadData()
            })
        }

    }
    
    @IBAction func onFavourite(_ sender: UIButton) {
        let button = sender
        let view = button.superview!
        let cell = view.superview as! TweetCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets![indexPath!.row]
        let path = tweet.id
        let favorited = tweet.favorited
        
        if favorited == false {
            TwitterClient.sharedInstance?.favorite(id: path!, params: nil) { (error) -> () in
                print("Favoriting")
                self.tweets![indexPath!.row].favoriteCount = self.tweets![indexPath!.row].favoriteCount! + 1
                tweet.favorited = true
                cell.favoritesButton.setImage(UIImage(named: "like_on"), for: UIControlState())
                self.tableView.reloadData()
            }
        } else if favorited ==  true {
            TwitterClient.sharedInstance?.unfavorite(id: path!, params: nil , completion: { (error) -> () in
                print("Unfavoriting")
                self.tweets![indexPath!.row].favoriteCount  = self.tweets![indexPath!.row].favoriteCount! - 1
                tweet.favorited = false
                cell.favoritesButton.setImage(UIImage(named: "like_off"), for: UIControlState())
                self.tableView.reloadData()
            })
        }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "tweetDetailSeque") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            
            let vc = segue.destination as! TweetDetailViewController
            vc.tweet = tweet
        }
    }
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
        
        if tweets != nil {
            cell.tweet = tweets?[indexPath.row]
            cell.selectionStyle = .none
        }
        return cell
    }
}
