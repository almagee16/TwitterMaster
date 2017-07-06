//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var name: String
    var screenname: String
    var profilePictureUrl: String
    var backgroundUrl: String?
    var dictionary: [String: Any]?
    var followerCount: Int
    var followingCount: Int
    var tagLine: String
    private static var _current: User?
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }

    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        print (dictionary)
        tagLine = dictionary["description"] as! String
        name = dictionary["name"] as! String
        screenname = "@" + (dictionary["screen_name"] as! String)
        profilePictureUrl = dictionary["profile_image_url_https"] as! String
        
        if dictionary["profile_banner_url"] != nil {
            backgroundUrl = dictionary["profile_banner_url"] as! String
            print ("This is the profile banner url \(backgroundUrl)")
        }
        
        followerCount = dictionary["followers_count"] as! Int
        followingCount = dictionary["friends_count"] as! Int
        
    }
}
