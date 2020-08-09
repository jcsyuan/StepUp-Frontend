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

protocol accessShopViewController { }

class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, accessShopViewController {
    
    
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var coins: UILabel!
    
    var shirt_models = [shopModel]()
    var pant_models = [shopModel]()
    var shoe_models = [shopModel]()
    var hair_models = [shopModel]()
    
    struct CoinData: Codable {
        let totCoins: Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopLabel.layer.masksToBounds = true
        shopLabel.layer.cornerRadius = 10
        
        shirt_models.append(shopModel(name: "Blue Shirt", category: 1, cost: 10, id: 1))
        shirt_models.append(shopModel(name: "Purple Shirt", category: 1, cost: 10, id: 2))
        shirt_models.append(shopModel(name: "Green Shirt", category: 1, cost: 15, id: 3))
        shirt_models.append(shopModel(name: "Pink Shirt", category: 1, cost: 20, id: 4))
        
        pant_models.append(shopModel(name: "Blue Pants", category: 2, cost: 30, id: 5))
        pant_models.append(shopModel(name: "Tan Pants", category: 2, cost: 35, id: 6))
        pant_models.append(shopModel(name: "Gray Pants", category: 2, cost: 50, id: 7))
        
        table.register(ShopTableViewCell.nib(), forCellReuseIdentifier: ShopTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
    }
    
    // get user data
    private func getUserData() {
        // load user data
        let url = URL(string: "http://127.0.0.1:5000/get-home-data")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempHomeData = try JSONDecoder().decode(CoinData.self, from: data)
                DispatchQueue.main.async {
                    self.coins.text = "\(tempHomeData.totCoins)"
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()
    }
    
    // table functions
    
    // number of rows
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
    
    // get shop data
    private func getShopData() {
        // load user data
        let url = URL(string: "http://127.0.0.1:5000/get-shop-data")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempShopData = try JSONDecoder().decode([shopModel].self, from: data)
                for tempItem in tempShopData {
                    if tempItem.category == 1 {
                        self.shirt_models.append(shopModel(name: tempItem.name, category: tempItem.category, cost: tempItem.cost, id: tempItem.id))
                    }
                    if tempItem.category == 2 {
                        self.pant_models.append(shopModel(name: tempItem.name, category: tempItem.category, cost: tempItem.cost, id: tempItem.id))
                    }
                    if tempItem.category == 3 {
                        self.shoe_models.append(shopModel(name: tempItem.name, category: tempItem.category, cost: tempItem.cost, id: tempItem.id))
                    }
                    if tempItem.category == 4 {
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

