//
//  BagCollectionViewCell.swift
//  SummerHack2020
//
//  Created by Natalie Wang on 8/6/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class BagCollectionViewCell: UICollectionViewCell {

    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!
    
    static let identifier = "BagCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "BagCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    public func configure(with model: bagModelStore) {
        self.myLabel.text = model.name
        self.myLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.myImageView.image = UIImage(named: model.name)
        self.myImageView.contentMode = .scaleAspectFit
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }

}
