//
//  TweetDetailViewController.swift
//  TwitterClientWK3
//
//  Created by Phạm Thanh Hùng on 7/2/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailViewController: UIViewController {
    var tweet: Tweet?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userImage.setImageWith((tweet?.user?.profileImageURL)!)
        userImage.layer.cornerRadius = 3
        userImage.clipsToBounds = true
        userName.text = tweet?.user?.name!
        userHandle.text = tweet?.user?.handle!
        tweetLabel.text = tweet?.tweetText!
        timeLabel.text = tweet?.timeAgoSince((tweet!.createdAt)!)
        retweetCountLabel.text = "\(tweet!.retweetCount!)"
        favoritesCountLabel.text = "\(tweet!.favoriteCount!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweetTapped(_ sender: UIButton) {
        let path = tweet!.id
        let retweeted = tweet!.retweeted
        
        if retweeted == false {
            TwitterClient.sharedInstance?.retweet(id: path!, params: nil) { (error) -> () in
                print("Retweeting")
                self.tweet!.retweetCount = self.tweet!.retweetCount! + 1
                self.tweet!.retweeted = true
                self.retweetButton.setImage(UIImage(named: "retweet_on"), for: UIControlState())
                self.viewDidLoad()
            }
        } else if retweeted ==  true {
            TwitterClient.sharedInstance?.unretweet(id: path!, params: nil , completion: { (error) -> () in
                print("Unretweeting")
                self.tweet!.retweetCount  = self.tweet!.retweetCount! - 1
                self.tweet!.retweeted = false
                self.retweetButton.setImage(UIImage(named: "retweet_off"), for: UIControlState())
                self.viewDidLoad()
            })
        }
    }

    @IBAction func onFavouriteTapped(_ sender: UIButton) {
        let path = tweet!.id
        let favorited = tweet!.favorited
        
        if favorited == false {
            TwitterClient.sharedInstance?.favorite(id: path!, params: nil) { (error) -> () in
                print("Favoriting")
                self.tweet!.favoriteCount = self.tweet!.favoriteCount! + 1
                self.tweet!.favorited = true
                self.favoritesButton.setImage(UIImage(named: "like_on"), for: UIControlState())
                self.viewDidLoad()
            }
        } else if favorited ==  true {
            TwitterClient.sharedInstance?.unfavorite(id: path!, params: nil , completion: { (error) -> () in
                print("Unfavoriting")
                self.tweet!.favoriteCount  = self.tweet!.favoriteCount! - 1
                self.tweet!.favorited = false
                self.favoritesButton.setImage(UIImage(named: "like_off"), for: UIControlState())
                self.viewDidLoad()
            })
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier) == "tweetReplySeque" {
            let vc = segue.destination as! ComposeViewController
            vc.tweet = self.tweet
            vc.isReply = true
        }
    }

}
