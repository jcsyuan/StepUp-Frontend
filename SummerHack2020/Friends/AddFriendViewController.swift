//
//  AddFriendViewController.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 6/26/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController {

    let status: [String] = ["no_user", "already_friends", "already_requested", "requested"]
    
    struct requestedStatus: Codable {
        let successful: String
    }
    
    @IBOutlet weak var addFriendLabel: UILabel!
    @IBOutlet weak var addSummary: UILabel!
    @IBOutlet weak var panelBg: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var entryUsername: UITextField!
    
    @IBAction func requestFriend(_ sender: Any) {
        
        let url = URL(string: "http://3.14.11.198:5000/send-friend-request")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))", "friend_username": self.entryUsername.text!])
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempStatus = try JSONDecoder().decode(requestedStatus.self, from: data)
                DispatchQueue.main.async {
                    if(tempStatus.successful == self.status[0]) {
                        // present alert
                        let message: String = "This user does not exist"
                        let titleText: String = "REQUEST FAILED"
                        let alertController:UIAlertController = UIAlertController(title: titleText, message: message, preferredStyle: UIAlertController.Style.alert)
                        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else if(tempStatus.successful == self.status[1]) {
                        // present alert
                        let message: String = "You are already friends with this user"
                        let titleText: String = "REQUEST FAILED"
                        let alertController:UIAlertController = UIAlertController(title: titleText, message: message, preferredStyle: UIAlertController.Style.alert)
                        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else if(tempStatus.successful == self.status[2]) {
                        // present alert
                        let message: String = "You already sent a friend request this user"
                        let titleText: String = "REQUEST FAILED"
                        let alertController:UIAlertController = UIAlertController(title: titleText, message: message, preferredStyle: UIAlertController.Style.alert)
                        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        // segue back to friends
                        self.dismiss(animated: true, completion: nil)
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

        // aesthetics
        addFriendLabel.layer.masksToBounds = true
        addFriendLabel.layer.cornerRadius = 25
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 10
        panelBg.layer.masksToBounds = true
        panelBg.layer.cornerRadius = 10
    }
    
    @IBAction func closeFriendRequest(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
