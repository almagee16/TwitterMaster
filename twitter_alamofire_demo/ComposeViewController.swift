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


class ComposeViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var textInput: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textInput = RSKPlaceholderTextView(frame: CGRect(x: 100, y: 100, width: self.view.frame.width, height: 100))
        //self.textInput.placeholder = "What's happening?"
        
        self.view.addSubview(self.textInput)
        
        profileImage.layer.cornerRadius = profileImage.frame.width * 0.1
        profileImage.layer.masksToBounds = true
        
        let user = User.current!
        let url = URL(string: user.profilePictureUrl)!
        profileImage.af_setImage(withURL: url)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    protocol ComposeViewControllerDelegate {
//        func did(post: Tweet)
//    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true) { 
            //
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
