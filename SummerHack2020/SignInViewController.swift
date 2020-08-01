//
//  SignInViewController.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 7/31/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

var token: String?
var user_id: Int?

struct defaultsKeys {
    static let userIdKey = "userIdKeyString"
    static let tokenKey = "tokenKeyString"
}

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // set defaults with web endpoint data
        let defaults = UserDefaults.standard
        defaults.set("replace with user_id", forKey: defaultsKeys.userIdKey)
        defaults.set("replace with token", forKey: defaultsKeys.tokenKey)

        // get defaults data
//        let defaults = UserDefaults.standard
//        if let user_id = defaults.string(forKey: defaultsKeys.userIdKey)
//        if let token = defaults.string(forKey: defaultsKeys.tokenKey)
    }
    
    

}
