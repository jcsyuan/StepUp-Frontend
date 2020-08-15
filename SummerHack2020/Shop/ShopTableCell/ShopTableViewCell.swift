//
//  ShopTableViewCell.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 8/8/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit
import BLTNBoard

class ShopTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var models = [shopModel]()
    var delegate: accessShopViewController?
    
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
    
    func configure(with models: [shopModel]) {
        self.models = models
        collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tempBoard = board(selectedItem: models[indexPath.row])
        tempBoard.delegate = delegate
        tempBoard.showBoard()
    }
}

class board {
    
    var delegate: accessShopViewController?
    var item: shopModel
    
    // initialize board class
    init(selectedItem: shopModel) {
        item = selectedItem
    }
    
    // initialize actual board
    private lazy var boardManager: BLTNItemManager = {
        let boardItem = BLTNPageItem(title: item.name)
        boardItem.image = resizeImage(image: UIImage(named: item.name)!, targetSize: CGSize(width: 300.0, height: 300.0))
        boardItem.actionButtonTitle = "BUY for \(item.cost) coins"
        boardItem.alternativeButtonTitle = "cancel"
        boardItem.appearance.actionButtonColor = #colorLiteral(red: 1, green: 0.5137547851, blue: 0.4823105335, alpha: 1)
        boardItem.appearance.alternativeButtonTitleColor = .gray
        boardItem.appearance.actionButtonFontSize = 22
        boardItem.appearance.alternativeButtonFontSize = 20
        boardItem.actionHandler = { _ in self.didTapBoardContinue() }
        boardItem.alternativeHandler = { _ in self.didTapBoardSkip() }
        return BLTNItemManager(rootItem: boardItem)
    }()
    
    // show board
    func showBoard() {
        boardManager.showBulletin(above: self.delegate as! UIViewController)
    }
    
    // try to buy item
    func didTapBoardContinue() {
        // not enough coins
        if delegate!.userCoins < item.cost {
            boardManager.dismissBulletin()
            delegate!.purchaseAlert()
        } else { // enough coins
            self.buyItem()
            
        }
    }
    
    // cancel buying item
    func didTapBoardSkip() {
        boardManager.dismissBulletin()
    }
    
    // buying item endpoint
    private func buyItem() {
        DispatchQueue.main.async {
            let url = URL(string: "http://3.14.11.198:5000/buy-item")!
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            request.httpMethod = "POST"
            request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))", "item_id": "\(self.item.id)", "item_cost": "\(self.item.cost)", "category_id":"\(self.item.category)"])
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.sync {
                    let vc = self.delegate as! UIViewController
                    vc.dismiss(animated: true, completion: nil)
                    self.delegate?.boughtItem()
                }
            }
            task.resume()
        }
    }
    
    // make image fit in board
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
