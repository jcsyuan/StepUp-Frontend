//
//  SignInViewController.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 7/31/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    struct loginCredentials: Codable {
        let user_id: Int
        let token: String
    }
    
    var usernameText: String = ""
    var passwordText: String = ""
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func continueAction(_ sender: Any) {
        self.usernameText = self.username.text!
        self.passwordText = self.password.text!
        
        let url = URL(string: "http://3.14.11.198:5000/login")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["username": self.usernameText, "password": self.passwordText])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempCredentials = try JSONDecoder().decode(loginCredentials.self, from: data)
                DispatchQueue.main.async {
                    if(tempCredentials.user_id == 0) {
                        print("wrong")
                        // present alert
                        let message: String = "The username or password you entered is not valid"
                        let titleText: String = "LOGIN FAILED"
                        let alertController:UIAlertController = UIAlertController(title: titleText, message: message, preferredStyle: UIAlertController.Style.alert)
                        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        print("right")
                        // segue to next viewcontroller
                        let defaults = UserDefaults.standard
                        defaults.set(tempCredentials.user_id, forKey: defaultsKeys.userIdKey)
                        defaults.set(tempCredentials.token, forKey: defaultsKeys.tokenKey)
                        defaults.set(true, forKey: defaultsKeys.loginKey)
                        self.performSegue(withIdentifier: "presentHome", sender: self)
                    }
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password.isSecureTextEntry = true
    }
}
