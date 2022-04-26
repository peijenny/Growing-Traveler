//
//  SignOutTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit

class SignUpTableViewCell: UITableViewCell {

    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var userPhotoLinkLabel: UILabel!
    
    @IBOutlet weak var uploadUserPhotoButton: UIButton!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userAccountTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var userCheckPasswordTextField: UITextField!
    
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
