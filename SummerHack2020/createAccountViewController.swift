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
        
        // json stuff
        let url = URL(string: "http://127.0.0.1:5000/initialize-account")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["username": "gn", "password": "secret", "display_name": "grace", "email": "grac@gmail.com", "coins": "1"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                print()
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()
    }
}


