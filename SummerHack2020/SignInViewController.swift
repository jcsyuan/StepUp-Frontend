//
//  SignInViewController.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 7/31/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

struct defaultsKeys {
    static let userIdKey = "userIdKeyString"
    static let tokenKey = "tokenKeyString"
}

class SignInViewController: UIViewController {
    var usernameText: String = ""
    var passwordText: String = ""
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var `continue`: UIButton!
    
    @IBAction func getVal () {
        usernameText = username.text!
        passwordText = password.text!
        
        let url = URL(string: "http://127.0.0.1:5000/login")!
               var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
               request.httpMethod = "POST"
               request.multipartFormData(parameters: ["username": usernameText, "password": passwordText])
               let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                   guard let data = data else { return }
                   do {
                       let tempCredentials = try JSONDecoder().decode(loginCredentials.self, from: data)
                       self.user_id = tempCredentials.user_id
                       self.token = tempCredentials.token
                   } catch let jsonErr {
                       print(jsonErr)
                       }
                   }
               //
               task.resume()
        
        //alert message
        if(self.user_id == 0) {
                  print("HI")
                  alert(message: "The username or password you entered is not valid", title: "LOGIN FAILED")
              } else {
                
                
                  // set defaults with web endpoint data
                  let defaults = UserDefaults.standard
                  defaults.set(self.user_id, forKey: defaultsKeys.userIdKey)
                  defaults.set(self.token, forKey: defaultsKeys.tokenKey)
              }
    }
    
    struct loginCredentials: Codable{
        let user_id: Int
        let token: Int
    }
    
    var user_id: Int = 0
    var token: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        // set defaults with web endpoint data
        
        // get defaults data
//        let defaults = UserDefaults.standard
//        if let user_id = defaults.string(forKey: defaultsKeys.userIdKey)
//        if let token = defaults.string(forKey: defaultsKeys.tokenKey)
    }
}

extension SignInViewController {
  func alert(message: String, title: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}