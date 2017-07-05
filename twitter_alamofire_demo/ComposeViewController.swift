//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Alvin Magee on 7/3/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import RSKPlaceholderTextView


class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var textInput: UITextView!
    
    @IBOutlet weak var tweetButton: UIButton!
    
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var placeHolderLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.textInput = RSKPlaceholderTextView(frame: CGRect(x: 100, y: 100, width: self.view.frame.width, height: 100))
//        self.textInput.placeholder = "What's happening?"
//        self.view.addSubview(self.textInput)
        textInput.delegate = self
        placeHolderLabel = UILabel()
        placeHolderLabel.text = "What's happening?"
        placeHolderLabel.sizeToFit()
        textInput.addSubview(placeHolderLabel)
        placeHolderLabel.frame.origin = CGPoint(x: 5, y: (textInput.font?.pointSize)! / 2)
        placeHolderLabel.textColor = UIColor.darkGray
        placeHolderLabel.isHidden = false

        profileImage.layer.cornerRadius = profileImage.frame.width * 0.5
        profileImage.layer.masksToBounds = true
        
        tweetButton.layer.cornerRadius = tweetButton.frame.width * 0.16
        tweetButton.layer.masksToBounds = true
        tweetButton.backgroundColor = UIColor.lightGray
        
        characterCountLabel.text = "140"
        
        let user = User.current!
        let url = URL(string: user.profilePictureUrl)!
        profileImage.af_setImage(withURL: url)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true) { 
            //
        }
    }
    
    func textViewDidChange(_ textInput: UITextView) {
        placeHolderLabel.isHidden = !textInput.text.isEmpty
        let text = textInput.text as! String
        let remainingCount = 140 - text.characters.count
        let count = text.characters.count
        
        if count == 0  {
            tweetButton.backgroundColor = UIColor.lightGray
            
            characterCountLabel.text = String(remainingCount)
            characterCountLabel.textColor = UIColor.black
        } else if count > 140 {
            tweetButton.backgroundColor = UIColor.lightGray
            
            characterCountLabel.text = String(remainingCount)
            characterCountLabel.textColor = UIColor.red
            
        } else {
            tweetButton.backgroundColor = tweetButton.tintColor
            
            characterCountLabel.text = String(remainingCount)
            characterCountLabel.textColor = UIColor.black
        }
        
    }
    
    @IBAction func onTweetButton(_ sender: Any) {
        let count = textInput.text.characters.count
        if count == 0 || count > 140 {
            // nothing should be done
        } else {
            APIManager.shared.composeTweet(with: textInput.text, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error composing Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.textInput.endEditing(true)
                    print("Compose Tweet Success!")
                    self.dismiss(animated: true, completion: { 
                        //
                    })
                }
            })
            
        }
        
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
