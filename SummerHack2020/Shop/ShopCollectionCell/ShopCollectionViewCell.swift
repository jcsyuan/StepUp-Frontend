//
//  ShopCollectionViewCell.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 8/8/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {

    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!
    
    static let identifier = "ShopCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ShopCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: Model) {
        self.myLabel.text = model.text
        self.myImageView.image = UIImage(named: model.imageName)
        self.myImageView.contentMode = .scaleAspectFill
    }
}
