//
//  SignInTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit

class SignInTableViewCell: UITableViewCell {

    @IBOutlet weak var userAccountTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
