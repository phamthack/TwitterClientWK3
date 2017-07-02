//
//  ComposeViewController.swift
//  TwitterClientWK3
//
//  Created by Phạm Thanh Hùng on 7/2/17.
//  Copyright © 2017 Phạm Thanh Hùng. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    var tweet: Tweet?
    var message: String = ""
    var isReply: Bool?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var characterCount: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        composeTextView.delegate = self
        composeTextView.becomeFirstResponder()
        
        profileImageView.setImageWith((User._currentUser?.profileImageURL)!)
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        tweetButton.layer.cornerRadius = 5
        usernameLabel.text = User._currentUser?.name
        userHandleLabel.text = User._currentUser?.handle
        
        if (isReply) == true {
            composeTextView.text = "@\((tweet?.user?.handle)!) "
        }
        characterCount.text = "\(140 - composeTextView.text!.characters.count)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tweetTapped(_ sender: UIButton) {
        self.message = composeTextView.text
        let escapedTweetMessage = self.message.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        if isReply == true {
            TwitterClient.sharedInstance?.reply(escapedTweet: escapedTweetMessage!, statusID: tweet!.id!, params: nil , completion: { (error) -> () in })
            isReply = false
            self.dismiss(animated: true, completion: {});
        } else {
            TwitterClient.sharedInstance?.compose(escapedTweet: escapedTweetMessage!, params: nil, completion: { (error) -> () in })
            self.dismiss(animated: true, completion: {});
        }
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
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

extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if  0 < (141 - composeTextView.text!.characters.count) {
            tweetButton.isEnabled = true
            characterCount.textColor = UIColor.darkGray
            characterCount.text = "\(140 - composeTextView.text!.characters.count)"
        } else {
            tweetButton.backgroundColor = UIColor.lightGray
            tweetButton.isEnabled = false
            characterCount.textColor = UIColor.red
            characterCount.text = "\(140 - composeTextView.text!.characters.count)"
        }
    }
}
