//
//  ShopViewController.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 7/1/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

// CHECK COINS TO MAKE SURE ENOUGH

class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var table: UITableView!
    @IBOutlet weak var coins: UILabel!
    
    var shirt_models = [Model]()
    var pant_models = [Model]()
    
    struct CoinData: Codable {
        let totCoins: Int
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shirt_models.append(Model(text: "First", imageName: "blue-shirt"))
        shirt_models.append(Model(text: "Second", imageName: "purple-shirt"))
        shirt_models.append(Model(text: "Third", imageName: "green-shirt"))
        shirt_models.append(Model(text: "Fourth", imageName: "pink-shirt"))
        shirt_models.append(Model(text: "First", imageName: "blue-shirt"))
        shirt_models.append(Model(text: "Second", imageName: "purple-shirt"))
        shirt_models.append(Model(text: "Third", imageName: "green-shirt"))
        shirt_models.append(Model(text: "Fourth", imageName: "pink-shirt"))
        
        pant_models.append(Model(text: "First", imageName: "blue-pants"))
        pant_models.append(Model(text: "Second", imageName: "tan-pants"))
        pant_models.append(Model(text: "Third", imageName: "gray-pants"))
        
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
            cell.configure(with: shirt_models)
        } else {
            cell.configure(with: pant_models)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
}
