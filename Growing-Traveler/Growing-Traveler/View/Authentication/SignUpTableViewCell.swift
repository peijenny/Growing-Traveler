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
    
    func getSignUpData() -> SignUp? {
        
        let userPhotoLink = userPhotoLinkLabel.text ?? ""
        
        guard let accountName = userNameTextField.text, userNameTextField.text != ""  else {
            
            hintLabel.text = "請輸入姓名！"
            
            return nil
        }
        
        guard let accountEmail = userAccountTextField.text, userAccountTextField.text != ""  else {
            
            hintLabel.text = "請輸入帳號！"
            
            return nil
            
        }
        
        guard let accountPassword = userPasswordTextField.text, userPasswordTextField.text != "" else {
            
            hintLabel.text = "請輸入密碼！"
            
            return nil
            
        }
        
        guard userCheckPasswordTextField.text != "" else {
            
            hintLabel.text = "請輸入檢查碼！"
            
            return nil
            
        }
        
        guard userPasswordTextField.text == userCheckPasswordTextField.text else {
            
            hintLabel.text = "密碼與檢查碼不一致！"
            
            return nil
            
        }
        
        guard accountEmail.range(of: "@") != nil else {
            
            hintLabel.text = "帳號格式錯誤！"
            
            return nil
            
        }
        
        guard accountPassword.count < 6 else {
            
            hintLabel.text = "密碼格式錯誤！"
            
            return nil
            
        }

        return SignUp(userName: accountName, userPhotoLink: userPhotoLink,
                      email: accountEmail, password: accountPassword)
        
    }
    
}
