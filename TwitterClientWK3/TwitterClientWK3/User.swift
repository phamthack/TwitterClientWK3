//
//  User.swift
//  TwitterClientWK3
//
//  Created by Phạm Thanh Hùng on 7/1/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import Foundation
class User {
    
    var name: String?
    var handle: String?
    var tagline: String?
    var profileImageURL: URL?
    var tagLine: String?
    var followerCount: Int?
    var followingCount: Int?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        handle = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        let profileImageString = dictionary["profile_image_url"] as? String
        if profileImageString != nil {
            profileImageURL = URL(string: profileImageString!)
        }
        
        followerCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                
                let defaults = UserDefaults.standard
                let currentUserData = defaults.object(forKey: "currentUserKey") as? Data
                if let currentUserData = currentUserData {
                    let dictionary = try! JSONSerialization.jsonObject(with: currentUserData, options: .allowFragments)
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(data, forKey: "currentUserKey")
            } else {
                defaults.set(nil, forKey: "currentUserKey")
            }
            defaults.synchronize()
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance?.requestSerializer.removeAccessToken()
        NotificationCenter.default.post(name: Notification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }

}
