//
//  LeaderBoardViewController.swift
//  SummerHack2020
//
//  Created by Natalie Wang on 7/6/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class LeaderBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var leaderBoardUsersList: [LeaderboardUser] = []
    
    struct LeaderboardUser: Codable {
        let displayName: String
        let steps: Int
    }
    
    struct LeaderboardList: Codable {
           let result: [LeaderboardUser]
    }
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        let user_id = UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey)
        let url = URL(string: "http://127.0.0.1:5000/leaderboard-data")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(user_id)"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempLeaderboardList = try JSONDecoder().decode(LeaderboardList.self, from: data)
                self.leaderBoardUsersList = tempLeaderboardList.result
                self.leaderBoardUsersList.sort { (lhs: LeaderboardUser, rhs: LeaderboardUser) in
                    // you can have additional code here
                    return lhs.steps < rhs.steps
                }
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        //        print(nameArray)
        task.resume()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        leaderBoardUsersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
        customCell.configure(with: indexPath.row, displayName: leaderBoardUsersList[indexPath.row].displayName, steps: leaderBoardUsersList[indexPath.row].steps)
        return customCell
        //        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //        cell.textLabel?.text = "Hello World"
        //        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
