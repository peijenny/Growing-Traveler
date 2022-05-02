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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getSignInData() -> SignIn? {
        
        guard let accountEmail = userAccountTextField.text, userAccountTextField.text != "" else {
            
            HUD.flash(.label("請輸入帳號！"), delay: 0.5)
            
            return nil
            
        }
        
        guard let accountPassword = userPasswordTextField.text, userPasswordTextField.text != "" else {
            
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
