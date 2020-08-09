//
//  BagViewController.swift
//  SummerHack2020
//
//  Created by Natalie Wang on 8/6/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class BagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    var shirt_models = [Model]()
    var pant_models = [Model]()
    
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
        
        // Do any additional setup after loading the view.
        table.register(BagCollectionTableViewCell.nib(), forCellReuseIdentifier: BagCollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false;
    }
    
    // set number of rows in table
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
            cell.configure(with: shirt_models)
        } else {
            cell.configure(with: pant_models)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

struct Model {
    let text: String
    let imageName: String
    
    init(text: String, imageName: String) {
        self.text = text
        self.imageName = imageName
    }
}
