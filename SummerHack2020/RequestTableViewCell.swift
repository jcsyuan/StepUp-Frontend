//
//  MyTableViewCell.swift
//  SummerHack2020
//
//  Created by Jonathan Yuan on 7/11/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

protocol RequestTableViewCellDelegate: AnyObject {
    func didAccept(with username: String)
    func didDecline(with username: String)
}

class RequestTableViewCell: UITableViewCell {

    weak var delegate: RequestTableViewCellDelegate?
    static let identifier = "RequestTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "RequestTableViewCell", bundle: nil)
    }
    
    private var username: String = ""
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func configure(with username: String) {
        self.username = username
        acceptButton.setTitle("accept", for: .normal)
        declineButton.setTitle("decline", for: .normal)
        usernameLabel.text = username
    }
    
    @IBAction func didAccept(_ sender: Any) {
        delegate?.didAccept(with: username)
    }
    
    @IBAction func didDecline(_ sender: Any) {
        delegate?.didDecline(with: username)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        declineButton.setTitleColor(UIColor.red, for: .normal)
//        declineButton.setTitleColor(UIColor.white, for: .selected)
//        acceptButton.setTitleColor(UIColor.green, for: .normal)
//        acceptButton.setTitleColor(UIColor.white, for: .selected)
    }
    
    
}
