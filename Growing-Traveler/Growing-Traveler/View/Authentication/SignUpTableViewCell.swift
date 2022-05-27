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
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uploadUserPhotoButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        uploadUserPhotoButton.cornerRadius = uploadUserPhotoButton.frame.width / 2
        
        userPhotoImageView.contentMode = .scaleAspectFill

        userPhotoImageView.cornerRadius = userPhotoImageView.frame.width / 2
        
        signUpButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        signUpButton.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setUserPhoto(userPhotoLink: String) {
        
        userPhotoLinkLabel.text = userPhotoLink
        
        userPhotoImageView.loadImage(userPhotoLink)
        
    }
    
    func getSignUpData() -> SignUp? {
        
        let userPhotoLink = userPhotoLinkLabel.text ?? ""
        
        guard let accountName = userNameTextField.text, !accountName.isEmpty else {
            
            HandleInputResult.nameEmpty.messageHUD
            
            return nil
        }
        
        guard let accountEmail = userAccountTextField.text, !accountEmail.isEmpty else {

            HandleInputResult.emailEmpty.messageHUD
            
            return nil
            
        }
        
        guard let accountPassword = userPasswordTextField.text, !accountPassword.isEmpty else {

            HandleInputResult.passwordEmpty.messageHUD
            
            return nil
            
        }
        
        guard let checkPassword = userPasswordTextField.text, !checkPassword.isEmpty else {
            
            HandleInputResult.checkEmpty.messageHUD
            
            return nil
            
        }
        
        guard userPasswordTextField.text == userCheckPasswordTextField.text else {
            
            HandleInputResult.passwordIsDifferent.messageHUD
            
            return nil
            
        }
        
        guard accountEmail.range(of: "@") != nil else {
            
            HandleInputResult.formatFailed.messageHUD

            return nil
            
        }
        
        return SignUp(userName: accountName, userPhotoLink: userPhotoLink,
                      email: accountEmail, password: accountPassword)
        
    }
    
}
