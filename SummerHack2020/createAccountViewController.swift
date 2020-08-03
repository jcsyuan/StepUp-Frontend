//
//  createAccountViewController.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 7/18/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class createAccountViewController: UIViewController {
    
    struct createValid: Codable {
        let created: String
       }
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var `continue`: UIButton!
    
    @IBAction func continueAction(_ sender: Any) {
        let url = URL(string: "http://127.0.0.1:5000/initialize-account")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["username": self.username.text!, "password": self.password.text!, "display_name": self.fullName.text!, "email": self.email.text!, "coins": "0"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempCreateValid = try JSONDecoder().decode(createValid.self, from: data)
                DispatchQueue.main.async {
                    if(tempCreateValid.created == "false") {
                        print("wrong")
                        // present alert
                        let message: String = "The username or email you entered is already associated with an account"
                        let titleText: String = "CREATE ACCOUNT FAILED"
                        let alertController:UIAlertController = UIAlertController(title: titleText, message: message, preferredStyle: UIAlertController.Style.alert)
                        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        print("right")
                        // segue to next viewcontroller
                        let defaults = UserDefaults.standard
                        defaults.set(self.user_id, forKey: defaultsKeys.userIdKey)
                        defaults.set(self.token, forKey: defaultsKeys.tokenKey)
                        self.performSegue(withIdentifier: "createTOhome", sender: self)
                    }
                }
                print()
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // json stuff
        
    }
}


