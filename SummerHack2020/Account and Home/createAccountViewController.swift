//
//  createAccountViewController.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 7/18/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

struct defaultsKeys {
    static let userIdKey = "userIdKeyString"
    static let tokenKey = "tokenKeyString"
    static let oldCoinsKey = "oldCoinsKeyString"
    static let oldDateKey = "oldDateKeyString"
    static let loginKey = "isUserLoggedInString"
}

class createAccountViewController: UIViewController {
    
    struct createValid: Codable {
        let created: String
        let user_id: Int
        let token: String
    }
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var `continue`: UIButton!
    
    @IBAction func continueAction(_ sender: Any) {
        let date = Calendar.current.startOfDay(for: Date())
        let modifiedDate = Calendar.current.date(byAdding: .day, value: -(Date().dayNumberOfWeek()! - 1), to:date)!
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone?
        let createdDate = dateFormatter.string(from: modifiedDate)
        let url = URL(string: "http://3.14.11.198:5000/initialize-account")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["username": self.username.text!, "password": self.password.text!, "display_name": self.fullName.text!, "email": self.email.text!, "coins": "0", "start_date": "\(createdDate)"])
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
                        let alertController: UIAlertController = UIAlertController(title: titleText, message: message, preferredStyle: UIAlertController.Style.alert)
                        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        print("right")
                        // segue to next viewcontroller
                        let defaults = UserDefaults.standard
                        defaults.set(tempCreateValid.user_id, forKey: defaultsKeys.userIdKey)
                        defaults.set(tempCreateValid.token, forKey: defaultsKeys.tokenKey)
                        defaults.set(0, forKey: defaultsKeys.oldCoinsKey)
                        defaults.set(Date().dayNumberOfWeek(), forKey: defaultsKeys.oldDateKey)
                        defaults.set(true, forKey: defaultsKeys.loginKey)
                        self.performSegue(withIdentifier: "createToHome", sender: self)
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
        
        password.isSecureTextEntry = true
    }
}


