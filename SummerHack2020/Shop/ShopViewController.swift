//
//  ShopViewController.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 7/1/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit
import BLTNBoard

// CHECK COINS TO MAKE SURE ENOUGH

protocol accessShopViewController {
    var userCoins: Int{ get set}
    func purchaseAlert()
    func boughtItem()
}

class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, accessShopViewController {
    
    
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var coins: UILabel!
    
    var shirt_models = [shopModel]()
    var pant_models = [shopModel]()
    var shoe_models = [shopModel]()
    var hair_models = [shopModel]()
    var userCoins: Int = 0
    
    struct CoinData: Codable {
        let totCoins: Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopLabel.layer.masksToBounds = true
        shopLabel.layer.cornerRadius = 10
        
        reloadAllData()
        
        table.register(ShopTableViewCell.nib(), forCellReuseIdentifier: ShopTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
    }
    
    // reload all data on shop
    func reloadAllData() {
        getShopData()
        getCoinData()
    }
    
    // not enough coins alert
    func purchaseAlert() {
        // send alert
        let message: String = "You do not have enough coins:("
        let titleText: String = "PURCHASE FAILED"
        let alertController:UIAlertController = UIAlertController(title: titleText, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // segue to bag controller
    func boughtItem() {
        performSegue(withIdentifier: "boughtItem", sender: nil)
    }
    
    // get coin data
    private func getCoinData() {
        // load user data
        let url = URL(string: "http://3.14.11.198:5000/get-coins")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempHomeData = try JSONDecoder().decode(CoinData.self, from: data)
                DispatchQueue.main.async {
                    self.coins.text = "\(tempHomeData.totCoins)"
                    self.userCoins = tempHomeData.totCoins
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()
    }
    
    // get shop data
    private func getShopData() {
        // load user data
        let url = URL(string: "http://3.14.11.198:5000/get-shop-data")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempShopData = try JSONDecoder().decode(shopModelArray.self, from: data)
                for tempItem in tempShopData.results {
                    if tempItem.category == 1 {
                        self.shirt_models.append(shopModel(name: tempItem.name, category: tempItem.category, cost: tempItem.cost, id: tempItem.id))
                    } else if tempItem.category == 2 {
                        self.pant_models.append(shopModel(name: tempItem.name, category: tempItem.category, cost: tempItem.cost, id: tempItem.id))
                    } else if tempItem.category == 3 {
                        self.shoe_models.append(shopModel(name: tempItem.name, category: tempItem.category, cost: tempItem.cost, id: tempItem.id))
                    } else {
                        self.hair_models.append(shopModel(name: tempItem.name, category: tempItem.category, cost: tempItem.cost, id: tempItem.id))
                    }
                }
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()
    }
    
    // table functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: ShopTableViewCell.identifier, for: indexPath) as! ShopTableViewCell
        if indexPath.row == 0 {
            cell.configure(with: shirt_models)
        } else if indexPath.row == 1 {
            cell.configure(with: pant_models)
        } else if indexPath.row == 2 {
            cell.configure(with: shoe_models)
        } else {
            cell.configure(with: hair_models)
        }
        cell.delegate = self
        cell.selectionStyle = .none;
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    
}

// to help decode shopModels from json
struct shopModelArray: Codable {
    let results: [shopModel]
}

// struct to store data for each item in the shop
struct shopModel: Codable {
    let name: String
    let category: Int
    let cost: Int
    let id: Int
    
    init(name: String, category: Int, cost: Int, id: Int) {
        self.name = name
        self.category = category
        self.cost = cost
        self.id = id
    }
}

