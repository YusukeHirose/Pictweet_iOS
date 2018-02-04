//
//  User.swift
//  Pictweet
//
//  Created by User on 2018/02/04.
//  Copyright © 2018年 User. All rights reserved.
//

import Foundation
import NCMB

class User {
    var userName: String
    var email: String
    var password: String

    init(userName: String, email: String, password: String) {
        self.userName = userName
        self.email = email
        self.password = password
    }
    
    func register(callback: @escaping (_ message: Error?) -> Void) {
        let user = NCMBUser()
        user.userName = userName
        user.mailAddress = email
        user.password = password
        user.signUpInBackground { error in
            callback(error)
        }
    }
    
    func login(callback: @escaping (_ message: Error?) -> Void) {
        NCMBUser.logInWithUsername(inBackground: self.userName, password: self.password) { user, error in
            callback(error)
        }
    }
}
