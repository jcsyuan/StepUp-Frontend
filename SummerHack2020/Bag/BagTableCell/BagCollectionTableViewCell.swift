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
    static let identifier = "BagCollectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "BagCollectionTableViewCell", bundle: nil)
    }
    
    func configure(with models: [bagModelStore]) {
        self.models = models
        bagCollectionView.reloadData()
    }
    
    @IBOutlet var bagCollectionView : UICollectionView!
    
    var models = [bagModelStore]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bagCollectionView.register(BagCollectionViewCell.nib(), forCellWithReuseIdentifier: BagCollectionViewCell.identifier)
        bagCollectionView.delegate = self
        bagCollectionView.dataSource = self
        bagCollectionView.showsHorizontalScrollIndicator = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Bag Collection View
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
    
    // press cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = bagCollectionView!.cellForItem(at: indexPath)
        cell?.backgroundColor = #colorLiteral(red: 1, green: 0.5137547851, blue: 0.4823105335, alpha: 0.2481271404)
        
        var tempItem = models[indexPath.row]
        tempItem.selected = true
        let category = tempItem.category
        if category == 1 {
            delegate!.worn_items[1].selected = false
            delegate!.worn_items[1] = tempItem
        } else if category == 2 {
            delegate!.worn_items[2].selected = false
            delegate!.worn_items[2] = tempItem
        } else if category == 3 {
            delegate!.worn_items[3].selected = false
            delegate!.worn_items[3] = tempItem
        } else {
            delegate!.worn_items[4].selected = false
            delegate!.worn_items[4] = tempItem
        }
        // success in reloading avatar
        delegate!.reloadAvatar()
        // failed to reload collections
        bagCollectionView.reloadData()
        delegate!.reloadTable()
        print(delegate!.worn_items)
    }
    
}
