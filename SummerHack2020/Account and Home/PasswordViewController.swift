//
//  PasswordViewController.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 6/29/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var submitPassword: UIButton!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    @IBAction func submitPassword(_ sender: Any) {
        let url = URL(string: "http://3.14.11.198:5000/change-password")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))", "old_password": self.oldPassword.text!, "new_password": self.newPassword.text!])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempPasswordChange = try JSONDecoder().decode(PasswordChange.self, from: data)
                DispatchQueue.main.async {
                    if(tempPasswordChange.changed == "false") {
                        print("wrong")
                        // present alert
                        let message: String = "The password you entered is invalid"
                        let titleText: String = "Password Change Failed"
                        let alertController:UIAlertController = UIAlertController(title: titleText, message: message, preferredStyle: UIAlertController.Style.alert)
                        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        print("right")
                        // segue to next viewcontroller
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()
    }
    
    struct PasswordChange: Codable {
        let changed: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.layer.masksToBounds = true
        background.layer.cornerRadius = 10
        
        submitPassword.layer.masksToBounds = true
        submitPassword.layer.cornerRadius = 10
    }
    
    @IBAction func closePassword(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
