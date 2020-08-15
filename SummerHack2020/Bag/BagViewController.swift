//
//  BagViewController.swift
//  SummerHack2020
//
//  Created by Natalie Wang on 8/6/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

protocol accessBagViewController {
    var worn_items: [bagModelStore] { get set }
    func reloadAvatar()
}

class BagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, accessBagViewController {
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var avatarShirt: UIImageView!
    @IBOutlet weak var avatarPants: UIImageView!
    @IBOutlet weak var avatarLeftShoe: UIImageView!
    @IBOutlet weak var avatarRightShoe: UIImageView!
    @IBOutlet weak var avatarBody: UIImageView!
    
    var shirt_models = [bagModelStore]()
    var pant_models = [bagModelStore]()
    var shoe_models = [bagModelStore]()
    var hair_models = [bagModelStore]()
    
    internal lazy var worn_items: [bagModelStore] = {
        var temp: [bagModelStore] = []
        temp.append(bagModelStore(name: "", category: 0, id: 0, selected: false))
        temp.append(bagModelStore(name: "", category: 0, id: 0, selected: false))
        temp.append(bagModelStore(name: "", category: 0, id: 0, selected: false))
        temp.append(bagModelStore(name: "", category: 0, id: 0, selected: false))
        temp.append(bagModelStore(name: "", category: 0, id: 0, selected: false))
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWornData {
            self.getUnwornData()
        }
        
        table.register(BagCollectionTableViewCell.nib(), forCellReuseIdentifier: BagCollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false;
    }
    
    func reloadAvatar() {
        avatarShirt.image = UIImage(named: self.worn_items[1].name)
        avatarPants.image = UIImage(named: self.worn_items[2].name)
        avatarLeftShoe.image = UIImage(named: self.worn_items[3].name)
        avatarRightShoe.image = UIImage(named: "\(self.worn_items[3].name)1")
        avatarBody.image = UIImage(named: "\(self.worn_items[4].name)-Avatar")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: BagCollectionTableViewCell.identifier, for: indexPath) as! BagCollectionTableViewCell
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    // sending worn items
    @IBAction func exitBag(_ sender: Any) {
        let url = URL(string: "http://3.14.11.198:5000/send-changed-worn-items")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))", "shirt_item_id": "\(self.worn_items[1].id)", "pant_item_id": "\(self.worn_items[2].id)", "shoes_item_id": "\(self.worn_items[3].id)", "hair_item_id": "\(self.worn_items[4].id)"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in }
        task.resume()
    }
    
    private func getWornData(completion: @escaping () -> ()) {
        // load user data
        let url = URL(string: "http://3.14.11.198:5000/get-worn-bag-data")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempBagData = try JSONDecoder().decode(bagModelArray.self, from: data)
                for tempItem in tempBagData.results {
                    let tempItemTwo = bagModelStore(name: tempItem.name, category: tempItem.category, id: tempItem.id, selected: true)
                    if tempItemTwo.category == 1 {
                        self.shirt_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                        self.worn_items[1] = bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected)
                    } else if tempItemTwo.category == 2 {
                        self.pant_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                        self.worn_items[2] = bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected)
                    } else if tempItemTwo.category == 3 {
                        self.shoe_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                        self.worn_items[3] = bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected)
                    } else {
                        self.hair_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                        self.worn_items[4] = bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected)
                    }
                }
                DispatchQueue.main.async {
                    self.table.reloadData()
                    self.avatarShirt.image = UIImage(named: self.worn_items[1].name)
                    self.avatarPants.image = UIImage(named: self.worn_items[2].name)
                    self.avatarLeftShoe.image = UIImage(named: self.worn_items[3].name)
                    self.avatarRightShoe.image = UIImage(named: "\(self.worn_items[3].name)1")
                    self.avatarBody.image = UIImage(named: "\(self.worn_items[4].name)-Avatar")
                    print("\(self.worn_items[4].name)-Avatar")
                }
            } catch let jsonErr {
                print(jsonErr)
            }
            completion()
        }
        task.resume()
    }
    
    
    private func getUnwornData() {
        // load user data
        let url = URL(string: "http://3.14.11.198:5000/get-unworn-bag-data")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempBagData = try JSONDecoder().decode(bagModelArray.self, from: data)
                for tempItem in tempBagData.results {
                    let tempItemTwo = bagModelStore(name: tempItem.name, category: tempItem.category, id: tempItem.id, selected: false)
                    print(tempItemTwo)
                    if tempItemTwo.category == 1 {
                        self.shirt_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                    }
                    if tempItemTwo.category == 2 {
                        self.pant_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                    }
                    if tempItemTwo.category == 3 {
                        self.shoe_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                    }
                    if tempItemTwo.category == 4 {
                        self.hair_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
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

struct bagModelArray: Codable {
    let results: [bagModelDecode]
}

struct bagModelDecode: Codable {
    let name: String
    let category: Int
    let id: Int
}

// struct to store data for each item in the shop
struct bagModelStore: Codable {
    let name: String
    let category: Int
    let id: Int
    var selected: Bool
    
    // ask about selected
    init(name: String, category: Int, id: Int, selected: Bool) {
        self.name = name
        self.category = category
        self.selected = selected
        self.id = id
    }
}
