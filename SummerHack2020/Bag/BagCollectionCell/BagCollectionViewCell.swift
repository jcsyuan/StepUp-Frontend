//
//  BagCollectionViewCell.swift
//  SummerHack2020
//
//  Created by Natalie Wang on 8/6/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class BagCollectionViewCell: UICollectionViewCell {

    @IBOutlet var myImageView: UIImageView!
    
    static let identifier = "BagCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "BagCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with model: bagModelStore) {
        self.myImageView.image = UIImage(named: model.name)
        self.myImageView.contentMode = .scaleAspectFit
        if model.selected {
            self.layer.backgroundColor = #colorLiteral(red: 1, green: 0.5137547851, blue: 0.4823105335, alpha: 0.2481271404)
        } else {
            self.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
    }

}
