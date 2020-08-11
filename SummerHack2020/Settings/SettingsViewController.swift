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
        logOutButton.layer.cornerRadius = 25
        logOutButton.layer.borderWidth = 0.5
        logOutButton.layer.borderColor = UIColor(red: 255/255.0, green: 131/255.0, blue: 123/255.0, alpha: 0.3).cgColor
        
        changePwButton.layer.masksToBounds = true
        changePwButton.layer.cornerRadius = 25
        changePwButton.layer.borderWidth = 0.5
        changePwButton.layer.borderColor = UIColor(red: 255/255.0, green: 131/255.0, blue: 123/255.0, alpha: 0.3).cgColor
        
        helpSupportButton.layer.masksToBounds = true
        helpSupportButton.layer.cornerRadius = 25
        helpSupportButton.layer.borderWidth = 1.5
        helpSupportButton.layer.borderColor = UIColor(red: 255/255.0, green: 131/255.0, blue: 123/255.0, alpha: 0.75).cgColor
        
        privacyButton.layer.masksToBounds = true
        privacyButton.layer.cornerRadius = 25
        privacyButton.layer.borderWidth = 1.5
        privacyButton.layer.borderColor = UIColor(red: 255/255.0, green: 131/255.0, blue: 123/255.0, alpha: 0.75).cgColor
        
        termsButton.layer.masksToBounds = true
        termsButton.layer.cornerRadius = 25
        termsButton.layer.borderWidth = 1.5
        termsButton.layer.borderColor = UIColor(red: 255/255.0, green: 131/255.0, blue: 123/255.0, alpha: 0.75).cgColor
        
    }

    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: defaultsKeys.loginKey)
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    

}
