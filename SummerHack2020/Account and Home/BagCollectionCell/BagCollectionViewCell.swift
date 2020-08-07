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
    
    public func configure(with model: Model) {
        self.myLabel.text = model.text
        self.myImageView.image = UIImage(named: model.imageName)
        self.myImageView.contentMode = .scaleAspectFit    }

}
