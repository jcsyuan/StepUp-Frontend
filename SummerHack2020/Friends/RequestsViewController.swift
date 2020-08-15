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
    var data: [String] = []
    var delegate: accessFriendsViewController?
    
    struct RequestList: Codable {
        let results: [String]
    }
    
    struct TempId: Codable {
        let friend_id: Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(RequestTableViewCell.nib(), forCellReuseIdentifier: RequestTableViewCell.identifier)
        table.dataSource = self
        
        // json stuff
        let url = URL(string: "http://3.14.11.198:5000/get-friend-requests")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let requestList = try JSONDecoder().decode(RequestList.self, from: data)
                self.data = requestList.results.sorted()
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        print(data)
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.identifier, for: indexPath) as! RequestTableViewCell
        // text in each cell
        cell.configure(with: data[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @IBAction func closeRequests(_ sender: Any) {
//        self.delegate?.getFriends()
//        dismiss(animated: true, completion: nil
        self.performSegue(withIdentifier: "returnFriends", sender: nil)
    }
}



extension RequestsViewController: RequestTableViewCellDelegate {
    
    func didAccept(with username: String) {
        print("\(username)")
        if let index = data.firstIndex(of: "\(username)") {
            data.remove(at: index)
        }
        
        //json stuff - dealing with request
        let url = URL(string: "http://3.14.11.198:5000/accept-decline-request")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))", "friend_username": username, "response": "accept"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
        }
        task.resume()
        table.reloadData()
    }
    
    func didDecline(with username: String) {
        print("\(username)")
        if let index = data.firstIndex(of: "\(username)") {
            data.remove(at: index)
        }
        
        //json stuff - dealing with request
        let url = URL(string: "http://3.14.11.198:5000/accept-decline-request")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))", "friend_username": username, "response": "decline"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
        }
        task.resume()
        
        table.reloadData()
    }
}

