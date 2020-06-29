//
//  SettingsViewController.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 6/28/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var changePwButton: UIButton!
    
    
    @IBOutlet weak var helpSupportButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logOutButton.layer.masksToBounds = true
        logOutButton.layer.cornerRadius = 10
        
        changePwButton.layer.masksToBounds = true
        changePwButton.layer.cornerRadius = 10
        
        helpSupportButton.layer.masksToBounds = true
        helpSupportButton.layer.cornerRadius = 10
        
        privacyButton.layer.masksToBounds = true
        privacyButton.layer.cornerRadius = 10
        
        termsButton.layer.masksToBounds = true
        termsButton.layer.cornerRadius = 10
        
    }
    

    

}
