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
    var friend_id: Int = -1
    
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
        let url = URL(string: "http://127.0.0.1:5000/get-friend-requests")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "17"])
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
}



extension RequestsViewController: RequestTableViewCellDelegate {
    
    func didAccept(with username: String) {
        print("\(username)")
        if let index = data.firstIndex(of: "\(username)") {
            data.remove(at: index)
        }
        
        let serialQueue = DispatchQueue(label: "acceptQueue")
        
        serialQueue.async {
            // json stuff - getting id of friend
            let url = URL(string: "http://127.0.0.1:5000/get-user-id")!
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            request.httpMethod = "POST"
            request.multipartFormData(parameters: ["username": username])
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let requestList = try JSONDecoder().decode(TempId.self, from: data)
                    self.friend_id = requestList.friend_id
                    print("first: \(self.friend_id)")
                } catch let jsonErr {
                    print(jsonErr)
                }
            }
            task.resume()
        }
        
        serialQueue.async {
            //json stuff - dealing with request
            let url2 = URL(string: "http://127.0.0.1:5000/accept-decline-request")!
            var request2 = URLRequest(url: url2, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            request2.httpMethod = "POST"
            request2.multipartFormData(parameters: ["user_id": "17", "friend_id": "\(self.friend_id)", "response": "accept"])
            print("second: \(self.friend_id)")
            let task2 = URLSession.shared.dataTask(with: request2) { (data, response, error) in
                guard let data = data else { return }
            }
            task2.resume()
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

