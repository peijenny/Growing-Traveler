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
    
    func getSignInData() -> SignIn? {
        
        guard let accountEmail = userAccountTextField.text, userAccountTextField.text != "" else {
            
            hintLabel.text = "請輸入帳號！"
            
            return nil
            
        }
        
        guard let accountPassword = userPasswordTextField.text, userPasswordTextField.text != "" else {
            
            hintLabel.text = "請輸入密碼！"
            
            return nil
            
        }
        
        guard accountEmail.range(of: "@") != nil else {
            
            hintLabel.text = "帳號格式錯誤！"
            
            return nil
            
        }
        
        return SignIn(email: accountEmail, password: accountPassword)
        
    }
    
}
