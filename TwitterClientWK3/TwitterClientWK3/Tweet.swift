//
//  Tweet.swift
//  TwitterClientWK3
//
//  Created by Phạm Thanh Hùng on 7/1/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import Foundation
class Tweet {
    
    var user: User?
    var createdAt: Date?
    var tweetText: String?
    var retweetCount: Int?
    var favoriteCount: Int?
    var id: Int?
    var retweeted: Bool?
    var favorited: Bool?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        if let timestampUnformatted = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.date(from: timestampUnformatted)
        }
        
        tweetText = (dictionary["text"] as? String)!
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favoriteCount = dictionary["favorite_count"] as? Int ?? 0
        
        id = dictionary["id"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        
    }
    
    class func tweetsWithArray(_ dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    // Reference CodepathDemo
    func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if components.year! >= 2 {
            return "\(String(describing: components.year!))y"
        }
        
        if components.year! >= 1 {
            return "1y"
        }
        
        if components.month! >= 2 {
            return "\(String(describing: components.month!))m"
        }
        
        if components.month! >= 1 {
            return "1m"
        }
        
        if components.weekOfYear! >= 2 {
            return "\(String(describing: components.weekOfYear!))w"
        }
        
        if components.weekOfYear! >= 1 {
            return "1w"
        }
        
        if components.day! >= 2 {
            return "\(String(describing: components.day!))d"
        }
        
        if components.day! >= 1 {
            return "1d"
        }
        
        if components.hour! >= 2 {
            return "\(String(describing: components.hour!))h"
        }
        
        if components.hour! >= 1 {
            return "1h"
        }
        
        if components.minute! >= 2 {
            return "\(String(describing: components.minute!))mi"
        }
        
        if components.minute! >= 1 {
            return "1m"
        }
        
        if components.second! >= 2 {
            return "\(String(describing: components.second!))s"
        }
        
        return "1s"
        
    }
}
