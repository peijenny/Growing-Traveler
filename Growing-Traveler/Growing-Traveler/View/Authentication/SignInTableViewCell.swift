//
//  SignInTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit
import PKHUD

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
            
            HUD.flash(.label("請輸入帳號！"), delay: 0.5)
            
            return nil
            
        }
        
        guard let accountPassword = userPasswordTextField.text, !accountPassword.isEmpty else {
            
            HUD.flash(.label("請輸入密碼！"), delay: 0.5)
            
            return nil
            
        }
        
        guard accountEmail.range(of: "@") != nil else {
            
            HUD.flash(.label("帳號格式錯誤！"), delay: 0.5)
            
            return nil
            
        }
        
        return SignIn(email: accountEmail, password: accountPassword)
        
    }
    
}
