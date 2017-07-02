//
//  TweetCell.swift
//  TwitterClientWK3
//
//  Created by Phạm Thanh Hùng on 7/1/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetTimestamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoritesCount: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            userImage.setImageWith((tweet.user?.profileImageURL!)!)
            userImage.layer.cornerRadius = 3
            userImage.clipsToBounds = true
            userName.text = tweet.user?.name
            userHandle.text = tweet.user?.handle
            tweetTimestamp.text = tweet.timeAgoSince(tweet.createdAt!)
            tweetText.text = tweet.tweetText
            retweetCount.text = "\(tweet.retweetCount!)"
            favoritesCount.text = "\(tweet.favoriteCount!)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
