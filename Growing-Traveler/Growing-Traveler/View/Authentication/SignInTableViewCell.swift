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
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        signInButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        signInButton.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func getSignInData() -> SignIn? {
        
        guard let accountEmail = userAccountTextField.text, !accountEmail.isEmpty else {
            
            HandleInputResult.emailEmpty.messageHUD
            
            return nil
            
        }
        
        guard let accountPassword = userPasswordTextField.text, !accountPassword.isEmpty else {
            
            HandleInputResult.passwordEmpty.messageHUD
            
            return nil
            
        }
        
        guard accountEmail.range(of: "@") != nil else {
            
            HandleInputResult.formatFailed.messageHUD
            
            return nil
            
        }
        
        return SignIn(email: accountEmail, password: accountPassword)
        
    }
    
}
