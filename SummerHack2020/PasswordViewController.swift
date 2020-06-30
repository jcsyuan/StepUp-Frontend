//
//  PasswordViewController.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 6/29/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var submitPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.layer.masksToBounds = true
        background.layer.cornerRadius = 10
        
        submitPassword.layer.masksToBounds = true
        submitPassword.layer.cornerRadius = 10
    }
    
    @IBAction func closePassword(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
