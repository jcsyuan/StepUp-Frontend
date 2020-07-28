//
//  FriendsViewController.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 6/25/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendsLabel: UILabel!
    
    var nameArray2: [Int] = []
    let nameArray = ["notlay", "kelai", "jojo", "bicky", "shon", "catherine", "mike", "maxwell", "varshinee", "nina", "lomeli", "calctaguy"]
    
    var searchingNames = [String()]
    
    var searching = false
    
    // object to hold friends list
    struct FriendList: Codable {
        let result: [Int]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rounding edges of label
        friendsLabel.layer.masksToBounds = true
        friendsLabel.layer.cornerRadius = 10
        
        // json stuff
        // prepare URL endpoint
        let url = URL(string: "http://127.0.0.1:5000/get-friends")!
        // instantiate request object
        var request = URLRequest(url: url)
        // declare type of method
        request.httpMethod = "POST"
        // set JSON body
        let tempIdDictionary: [String: String] = ["user_id": "17"]
        let jsonBody = try? JSONSerialization.data(withJSONObject: tempIdDictionary)
        request.httpBody = jsonBody
        // call endpoint
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // error check
            guard let data = data else { return }
            // decode returned json object
            do {
                print(data)
                let friendList = try JSONDecoder().decode(FriendList.self, from: data)
                print(friendList.result)
            } catch let jsonErr { // error check
                print(jsonErr)
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingNames.count
        } else {
            return nameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching {
            cell?.textLabel?.text = searchingNames[indexPath.row]
        } else {
            cell?.textLabel?.text = nameArray[indexPath.row]
        }
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingNames = nameArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tblView.reloadData()
    }
    

}
