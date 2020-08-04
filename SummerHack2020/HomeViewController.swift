//
//  HomeViewController.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 8/1/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Name.text = "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"
        
    }

}
