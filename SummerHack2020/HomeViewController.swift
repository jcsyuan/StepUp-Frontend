//
//  HomeViewController.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 8/1/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var Name: UILabel!
    
    var username: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let user_id = defaults.integer(forKey: defaultsKeys.userIdKey)
        let token = defaults.string(forKey: defaultsKeys.tokenKey)
        
        Name.text = "\(user_id)"
        
    }

}
