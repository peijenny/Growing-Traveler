//
//  ErrorManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/30.
//

import Foundation
import FirebaseAuth
import PKHUD

class ErrorManager {
    
    func handleAuthError(errorCode: AuthErrorCode) {
        
        switch errorCode {
            
        // API Error
        case .networkError:
            
            HUD.flash(.labeledError(title: "網路錯誤！", subtitle: "請重新登入"))
            
            print("網路錯誤！請重新登入！")
            
        case .userNotFound:
            
            HUD.flash(.labeledError(title: "未找到此帳戶！", subtitle: "請確認帳號是否正確"))
            
            print("未找到此帳戶！請確認帳號是否正確！")
            
        case .userTokenExpired:
            
            HUD.flash(.labeledError(title: "Token 過期！", subtitle: "請重新登入"))
            
            print("Token 過期！請重新登入！")
            
        case .tooManyRequests:
            
            HUD.flash(.labeledError(title: "登入次數頻繁！", subtitle: "請稍後再登入"))
            
            print("登入次數頻繁！請稍後再登入！")
            
        case .appNotAuthorized:
            
            HUD.flash(.labeledError(title: "App 無權使用 API！", subtitle: "請稍後再登入"))
            
            print("App 無權使用 Firebase API！")
            
        case .keychainError:
            
            HUD.flash(.labeledError(title: "App 金鑰錯誤！", subtitle: nil))
            
            print("App 金鑰錯誤！")
            
        case .internalError:
            
            HUD.flash(.labeledError(title: "App 內部錯誤！", subtitle: nil))
            
            print("App 內部錯誤！")
            
        // SignIn Error
        case .invalidEmail:
            
            HUD.flash(.labeledError(title: "Email 格式錯誤！", subtitle: nil))

            print("Email 格式錯誤！")
            
        case .operationNotAllowed:
            
            HUD.flash(.labeledError(title: "Email 未註冊！", subtitle: nil))
            
            print("Email 未註冊！")
            
        case .userDisabled:
            
            HUD.flash(.labeledError(title: "此帳號已被封鎖！", subtitle: nil))
            
            print("此帳號已被封鎖！")
            
        case .wrongPassword:
            
            HUD.flash(.labeledError(title: "登入密碼錯誤！", subtitle: nil))
            
            print("登入密碼錯誤！")
            
        // SignUp Error
        case .emailAlreadyInUse:
            
            HUD.flash(.labeledError(title: "Email 已被註冊！", subtitle: nil))
            
            print("Email 已被註冊了！")
            
        case .weakPassword:
            
            HUD.flash(.labeledError(title: "密碼太弱！", subtitle: "請使用別的密碼"))
            
            print("密碼太弱！請使用別的密碼！")
            
        default: break
            
        }
        
    }
    
}
