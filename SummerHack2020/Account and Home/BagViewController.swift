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
    
    var models = [Model]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        models.append(Model(text: "First", imageName: "Image-1"))
        models.append(Model(text: "Second", imageName: "Image-2"))
        models.append(Model(text: "Third", imageName: "Image-3"))
        models.append(Model(text: "Fourth", imageName: "Image-4"))
        
        models.append(Model(text: "First", imageName: "Image-1"))
        models.append(Model(text: "Second", imageName: "Image-2"))
        models.append(Model(text: "Third", imageName: "Image-3"))
        models.append(Model(text: "Fourth", imageName: "Image-4"))
        
        models.append(Model(text: "First", imageName: "Image-1"))
        models.append(Model(text: "Second", imageName: "Image-2"))
        models.append(Model(text: "Third", imageName: "Image-3"))
        models.append(Model(text: "Fourth", imageName: "Image-4"))
        
        models.append(Model(text: "First", imageName: "Image-1"))
        models.append(Model(text: "Second", imageName: "Image-2"))
        models.append(Model(text: "Third", imageName: "Image-3"))
        models.append(Model(text: "Fourth", imageName: "Image-4"))
        
        // Do any additional setup after loading the view.
        table.register(BagCollectionTableViewCell.nib(), forCellReuseIdentifier: BagCollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
    }
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: BagCollectionTableViewCell.identifier, for: indexPath) as! BagCollectionTableViewCell
        
        cell.configure(with: models)
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
