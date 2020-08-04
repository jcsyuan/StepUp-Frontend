//
//  HomeViewController.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 8/1/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var weeklySteps: UILabel!
    @IBOutlet weak var totalSteps: UILabel!
    @IBOutlet weak var todaySteps: UILabel!
    @IBOutlet weak var coins: UILabel!
    
   struct HomeData: Codable {
        let username: String
        let name: String
        let weekSteps: Int
        let totSteps: Int
        let todayStep: Int
        let totCoins: Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://127.0.0.1:5000/get-home-data")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempHomeData = try JSONDecoder().decode(HomeData.self, from: data)
                DispatchQueue.main.async {
                    self.Username.text = tempHomeData.username
                    self.Name.text = tempHomeData.name
                    self.weeklySteps.text = "\(tempHomeData.weekSteps)"
                    self.totalSteps.text = "\(tempHomeData.totSteps)"
                    self.todaySteps.text = "\(tempHomeData.todayStep)"
                    self.coins.text = "\(tempHomeData.totCoins)"
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        //        print(nameArray)
        task.resume()
        
    }

}
