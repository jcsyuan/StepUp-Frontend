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
    
    public func configure(with model: shopModel) {
        self.myLabel.text = "\(model.cost)"
        self.myImageView.image = UIImage(named: model.name)
        self.myImageView.contentMode = .scaleAspectFit
        
//        self.layer.borderWidth = 5
//        self.layer.borderColor = #colorLiteral(red: 1, green: 0.5137547851, blue: 0.4823105335, alpha: 1)
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
}
