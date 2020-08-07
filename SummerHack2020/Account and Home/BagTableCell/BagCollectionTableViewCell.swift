//
//  BagCollectionTableViewCell.swift
//  SummerHack2020
//
//  Created by Natalie Wang on 8/6/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class BagCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    static let identifier = "BagCollectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "BagCollectionTableViewCell", bundle: nil)
    }
    
    func configure(with models: [Model]) {
        self.models = models
        bagCollectionView.reloadData()
    }
    
    @IBOutlet var bagCollectionView : UICollectionView!
    
    var models = [Model]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bagCollectionView.register(BagCollectionViewCell.nib(), forCellWithReuseIdentifier: BagCollectionViewCell.identifier)
        bagCollectionView.delegate = self
        bagCollectionView.dataSource = self
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
        return CGSize(width: 100, height: 100)
    }
}
