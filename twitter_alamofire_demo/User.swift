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
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as! String
        screenname = "@" + (dictionary["screen_name"] as! String)
        profilePictureUrl = dictionary["profile_image_url_https"] as! String

        
    }
}
