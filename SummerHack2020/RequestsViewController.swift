//
//  RequestsViewController.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 7/11/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    var data = ["j0nathing", "chickenwang", "pikachiu"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        table.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
        // text in each cell
        cell.configure(with: data[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension RequestsViewController: MyTableViewCellDelegate {
    func didAccept(with username: String) {
        print("\(username)")
        if let index = data.firstIndex(of: "\(username)") {
            data.remove(at: index)
        }
        table.reloadData()
    }
    
    func didDecline(with username: String) {
        print("\(username)")
        if let index = data.firstIndex(of: "\(username)") {
            data.remove(at: index)
        }
        table.reloadData()
    }
}

