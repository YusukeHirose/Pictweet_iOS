//
//  Tweet.swift
//  Pictweet
//
//  Created by User on 2018/02/10.
//  Copyright © 2018年 User. All rights reserved.
//

import UIKit
import NCMB

class Tweet {
    var imageFileName: String
    var comment: String
    
    init(imageFileName: String, comment: String) {
        self.imageFileName = imageFileName
        self.comment = comment
    }
    
    func save() {
        let tweetObject = NCMBObject(className: "Tweet")
        tweetObject?.setObject(imageFileName, forKey: "imageFileName")
        tweetObject?.setObject(comment, forKey: "comment")
        tweetObject?.saveInBackground { error in
            if error == nil {
                print("保存完了")
            }
        }
    }
}


