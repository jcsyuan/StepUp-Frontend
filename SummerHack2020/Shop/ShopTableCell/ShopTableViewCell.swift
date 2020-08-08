//
//  ShopTableViewCell.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 8/8/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var models = [Model]()
    
    static let identifier = "ShopTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ShopTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(ShopCollectionViewCell.nib(), forCellWithReuseIdentifier: ShopCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configure(with models: [Model]) {
        self.models = models
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCollectionViewCell.identifier, for: indexPath) as! ShopCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
}
