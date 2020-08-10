//
//  BagCollectionTableViewCell.swift
//  SummerHack2020
//
//  Created by Natalie Wang on 8/6/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class BagCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: accessBagViewController?
    var models = [bagModelStore]()
    
    static let identifier = "BagCollectionTableViewCell"
    
    @IBOutlet var bagCollectionView : UICollectionView!
    
    static func nib() -> UINib {
        return UINib(nibName: "BagCollectionTableViewCell", bundle: nil)
    }
    
    func configure(with models: [bagModelStore]) {
        self.models = models
        bagCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bagCollectionView.register(BagCollectionViewCell.nib(), forCellWithReuseIdentifier: BagCollectionViewCell.identifier)
        bagCollectionView.delegate = self
        bagCollectionView.dataSource = self
        bagCollectionView.showsHorizontalScrollIndicator = false
    }
    
    // BagCollectionView functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bagCollectionView.dequeueReusableCell(withReuseIdentifier: BagCollectionViewCell.identifier, for: indexPath) as! BagCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    // selecting item to wear
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // change selected to false for old item
        for itemIndex in 0...models.count - 1 {
            if models[itemIndex].selected {
                models[itemIndex].selected = false
            }
        }
        // change selected to true for new item
        models[indexPath.row].selected = true
        // replace worn items array with new item
        let tempItem = models[indexPath.row]
        let category = tempItem.category
        if category == 1 {
            delegate!.worn_items[1] = tempItem
        } else if category == 2 {
            delegate!.worn_items[2] = tempItem
        } else if category == 3 {
            delegate!.worn_items[3] = tempItem
        } else {
            delegate!.worn_items[4] = tempItem
        }
        // reload avatar
        delegate!.reloadAvatar()
        // reload table cell
        bagCollectionView.reloadData()
    }
}
