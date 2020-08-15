//
//  FriendsViewController.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 6/25/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

protocol accessFriendsViewController {
    func getFriends()
}

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, accessFriendsViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendsLabel: UILabel!
    
    @IBAction func requestsButton(_ sender: Any) {
        guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "RequestsViewControllerId") as? RequestsViewController
            else {
            print("failed")
            return
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    var nameArray: [String] = []
    
    var searchingNames = [String()]
    
    var searching = false
    
    // object to hold friends list
    struct FriendList: Codable {
        let result: [String]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rounding edges of label
        friendsLabel.layer.masksToBounds = true
        friendsLabel.layer.cornerRadius = 10
        
        // json stuff
        getFriends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFriends()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFriends()
    }
    
    func getFriends() {
        let url = URL(string: "http://3.14.11.198:5000/get-friends")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let friendList = try JSONDecoder().decode(FriendList.self, from: data)
                self.nameArray = friendList.result.sorted()
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            } catch let jsonErr {
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

extension URLRequest {
    
    struct MultipartFile {
        var data: Data
        var mimeType, filename: String
    }
    
    mutating func multipartFormData(
        parameters: [String: String] = [:],
        files: [MultipartFile] = []) {
        
        var body = Data()
        let boundary = "Boundary-\(UUID().uuidString)"
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body + boundaryPrefix
            body + "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
            body + "\(value)\r\n"
        }
        
        for file in files {
            body + boundaryPrefix
            body + "Content-Disposition: form-data; name=\"file\"; filename=\"\(file.filename)\"\r\n"
            body + "Content-Type: \(file.mimeType)\r\n\r\n"
            body.append(file.data)
            body + "\r\n"
        }
        
        body + "--".appending(boundary.appending("--"))
        
        httpBody = body
        httpMethod = httpMethod == "GET" ? "POST" : httpMethod
        setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    }
}

extension Data {
    static func + (data: inout Data, string: String) {
        data.append(Data(string.utf8))
    }
}
