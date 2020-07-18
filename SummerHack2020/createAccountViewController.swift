//
//  createAccountViewController.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 7/18/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class createAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountJson()
    }
    
    func createAccountJson() {
        // prepare json data
        let json: [String: Any] = ["username": "pikachiu", "password": "secret", "display_name": "kelly", "email": "pikachiu@gmail.com", "coins": "200"]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "http://127.0.0.1:5000/create-tables")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // insert json data to the request
//        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
    }
}
