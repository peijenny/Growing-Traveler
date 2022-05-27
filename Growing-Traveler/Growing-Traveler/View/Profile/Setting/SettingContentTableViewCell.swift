//
//  SettingContentTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit

class SettingContentTableViewCell: UITableViewCell {

    @IBOutlet weak var userIDTextField: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPhoneTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showUserContent(userInfo: UserInfo) {
        
        userIDTextField.text = userInfo.userID
        
        userNameTextField.text = userInfo.userName
        
        userEmailTextField.text = userInfo.userEmail
        
        userPhoneTextField.text = userInfo.userPhone
        
    }
    
    func checkFullIn(userInfo: UserInfo) -> UserInfo? {
        
        var updateUserInfo = userInfo
        
        guard let userName = userNameTextField.text,
              userNameTextField.text != nil else {
            
            HandleInputResult.nameEmpty.messageHUD
            
            return nil
            
        }
        
        guard let userEmail = userEmailTextField.text,
                userEmailTextField.text != nil else {
            
            HandleInputResult.emailEmpty.messageHUD
            
            return nil
            
        }
        
        if let userPhone = userPhoneTextField.text {
            
            updateUserInfo.userPhone = userPhone
            
        }
        
        updateUserInfo.userName = userName
        
        updateUserInfo.userEmail = userEmail
        
        return updateUserInfo
        
    }
    
}
