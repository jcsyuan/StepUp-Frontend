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
    
    var shirt_models = [Model]()
    var pant_models = [Model]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shirt_models.append(Model(text: "First", imageName: "blue-shirt"))
        shirt_models.append(Model(text: "Second", imageName: "orange-shirt"))
        shirt_models.append(Model(text: "Third", imageName: "green-shirt"))
        shirt_models.append(Model(text: "Fourth", imageName: "pink-shirt"))
        shirt_models.append(Model(text: "First", imageName: "blue-shirt"))
        shirt_models.append(Model(text: "Second", imageName: "orange-shirt"))
        shirt_models.append(Model(text: "Third", imageName: "green-shirt"))
        shirt_models.append(Model(text: "Fourth", imageName: "pink-shirt"))
        
        pant_models.append(Model(text: "First", imageName: "blue-pants"))
        pant_models.append(Model(text: "Second", imageName: "tan-pants"))
        pant_models.append(Model(text: "Third", imageName: "gray-pants"))
        
//        models.append(Model(text: "Lime $10", imageName: "shirt-1"))
//        models.append(Model(text: "Blueberry $8", imageName: "shirt-2"))
//        models.append(Model(text: "Snow $15", imageName: "shirt-3"))
//
//        models.append(Model(text: "Jeans $35", imageName: "pant-1"))
//        models.append(Model(text: "second", imageName: "Image-1"))
//        models.append(Model(text: "third", imageName: "Image-2"))
//        models.append(Model(text: "fourth", imageName: "Image-3"))
//
//        models.append(Model(text: "Converse $30", imageName: "shoe-1"))
//        models.append(Model(text: "second", imageName: "Image-1"))
//        models.append(Model(text: "third", imageName: "Image-2"))
//        models.append(Model(text: "fourth", imageName: "Image-3"))
        
        table.register(KelCollectionTableViewCell.nib(), forCellReuseIdentifier: KelCollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
    }
    
    // Table
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: KelCollectionTableViewCell.identifier, for: indexPath) as! KelCollectionTableViewCell
       
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
        return 250.0
    }
    
//    struct Model {
//        let text: String
//        let imageName: String
//
//        init(text: String, imageName: String) {
//            self.text = text
//            self.imageName = imageName
//        }
//    }
}
