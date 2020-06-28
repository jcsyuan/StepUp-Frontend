//
//  AddFriendViewController.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 6/26/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController {

    @IBOutlet weak var addFriendLabel: UILabel!
    @IBOutlet weak var addSummary: UILabel!
    
    @IBOutlet weak var panelBg: UIImageView!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addFriendLabel.layer.masksToBounds = true
        addFriendLabel.layer.cornerRadius = 25

        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 10
        
        
        panelBg.layer.masksToBounds = true
        panelBg.layer.cornerRadius = 10
        


    }
    
}
