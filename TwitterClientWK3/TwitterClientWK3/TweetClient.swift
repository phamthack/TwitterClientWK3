//
//  TweetClient.swift
//  TwitterClientWK3
//
//  Created by Phạm Thanh Hùng on 7/1/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "WXDzqIuXxCgk0VQXFTiFGd4hB", consumerSecret: "7lxaGGT5Lj1mp5LtZsdaQvO1hGmQbIeXPoHrtiTFfRlio1vUfn")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func currentAccount(_ success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, success: { (task: URLSessionDataTask, response: AnyObject?) in
            let user = User(dictionary: response as! NSDictionary)
            success(user)
            } as! (URLSessionDataTask, Any?) -> Void, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
                
            } as! (URLSessionDataTask?, Error) -> Void)
    }
    
    func handleOpenUrl(_ url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            self.currentAccount({ (user :User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            self.loginSuccess?()
        }, failure: { (error: (Error!)) in
            self.loginFailure?(error)
            
        })
        
    }
    
    func login (success: @escaping () -> (), error: (Error) -> ()) {
        self.loginSuccess = success
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterclientWK3://oauth"), scope: nil, success: { (response: BDBOAuth1Credential!) -> Void in
            
            if let response = response {
                self.loginSuccess?()
                print(response.token)
                
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
                
                UIApplication.shared.open(authURL!, options: [:], completionHandler: nil)
            }
            
        }, failure: { (error: (Error!)) in
            self.loginFailure?(error)
            
        })
    }
    
    func homeTimeline(_ success: @escaping ([Tweet]) ->  (), failure: ((NSError) -> ())?) {
        get("1.1/statuses/home_timeline.json", parameters: nil, success: { (task: URLSessionDataTask, response: AnyObject?) in
            let tweets = response as! [NSDictionary]
            success(Tweet.tweetsWithArray(tweets))
            } as! (URLSessionDataTask, Any?) -> Void, failure: { (task: URLSessionDataTask?, error: NSError) -> Void in
                if let failure = failure {
                    failure(error)
                }
                } as! (URLSessionDataTask?, Error) -> Void)
    }
}
