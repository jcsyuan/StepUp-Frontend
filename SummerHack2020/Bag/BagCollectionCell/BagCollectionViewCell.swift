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
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }

}
