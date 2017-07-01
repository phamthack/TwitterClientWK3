//
//  Tweet.swift
//  TwitterClientWK3
//
//  Created by Phạm Thanh Hùng on 7/1/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import Foundation
class Tweet {
    var profileUrl: URL?
    var username: String?
    var time: Date?
    var tweet: String?
    var user: User?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        let timeString = dictionary["created_at"] as? String
        if let timeString = timeString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            time = formatter.date(from: timeString)
        }
    }
    
    class func tweetsWithArray(_ dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if components.year! >= 2 {
            return "\(components.year)y"
        }
        
        if components.year! >= 1 {
            return "1y"
        }
        
        if components.month! >= 2 {
            return "\(components.month)m"
        }
        
        if components.month! >= 1 {
            return "1m"
        }
        
        if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear)w"
        }
        
        if components.weekOfYear! >= 1 {
            return "1w"
        }
        
        if components.day! >= 2 {
            return "\(components.day)d"
        }
        
        if components.day! >= 1 {
            return "1d"
        }
        
        if components.hour! >= 2 {
            return "\(components.hour)h"
        }
        
        if components.hour! >= 1 {
            return "1h"
        }
        
        if components.minute! >= 2 {
            return "\(components.minute)m"
        }
        
        if components.minute! >= 1 {
            return "1m"
        }
        
        if components.second! >= 2 {
            return "\(components.second)s"
        }
        
        return "1s"
        
    }

}
