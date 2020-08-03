//
//  MyTableViewCell.swift
//  SummerHack2020
//
//  Created by Natalie Wang on 7/6/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    static let identifier = "MyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }
    
    public func configure(with rank: Int, displayName: String, steps: Int) {
        myRank.text = "\(rank)"
        myDisplayName.text = displayName
        mySteps.text = "\(steps)"
    }
    
    @IBOutlet var myRank : UILabel!
    @IBOutlet var mySteps: UILabel!
    @IBOutlet weak var myDisplayName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
