//
//  ErrorManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/30.
//

import Foundation
import FirebaseAuth
import PKHUD

enum AuthError {
    
    case networkError
    
    case userNotFound
    
    case userTokenExpired
    
    case tooManyRequests
    
    case appNotAuthorized
    
    case keychainError
    
    case internalError
    
    case invalidEmail
    
    case operationNotAllowed
    
    case userDisabled
    
    case wrongPassword
    
    case emailAlreadyInUse
    
    case weakPassword
    
    case defaultError
    
    var title: String {
        
        switch self {
            
        case .appNotAuthorized: return "App 無權使用 API！"
            
        case .networkError: return "網路錯誤！"
            
        case .userNotFound: return "未找到此帳戶！"
            
        case .userTokenExpired: return "Token 過期！"
            
        case .tooManyRequests: return "登入次數頻繁！"
            
        case .keychainError: return "App 金鑰錯誤！"
            
        case .internalError: return "App 內部錯誤！"
            
        case .invalidEmail: return "Email 格式錯誤！"
            
        case .operationNotAllowed: return "Email 未註冊！"
            
        case .userDisabled: return "此帳號已被封鎖！"
            
        case .wrongPassword: return "登入密碼錯誤！"
            
        case .emailAlreadyInUse: return "Email 已被註冊！"
            
        case .weakPassword: return "密碼太弱！"
            
        case .defaultError: return "內部發生錯誤！"
            
        }
        
    }
    
    var subTitle: String {
        
        switch self {
            
        case .appNotAuthorized: return "請重新登入"
            
        case .networkError: return "請稍後再登入"
            
        case .userNotFound: return "請確認帳號是否正確"
            
        case .userTokenExpired: return "請重新登入"
            
        case .tooManyRequests: return "請稍後再登入"
            
        case .keychainError: return "請重新登入"
            
        case .internalError: return ""
            
        case .invalidEmail: return ""
            
        case .operationNotAllowed: return ""
            
        case .userDisabled: return ""
            
        case .wrongPassword: return ""
            
        case .emailAlreadyInUse: return ""
            
        case .weakPassword: return "請使用別的密碼"
            
        case .defaultError: return "請稍後再試"
            
        }
        
    }
    
}

class ErrorManager {
    
    func handleAuthError(errorCode: AuthErrorCode) {
        
        switch errorCode {

        case .networkError:
            
            HUD.flash(.labeledError(title: AuthError.networkError.title,
                subtitle: AuthError.networkError.subTitle), delay: 0.5)
            
        case .userNotFound:
            
            HUD.flash(.labeledError(title: AuthError.userNotFound.title,
                subtitle: AuthError.userNotFound.subTitle), delay: 0.5)

        case .userTokenExpired:
            
            HUD.flash(.labeledError(title: AuthError.userTokenExpired.title,
                subtitle: AuthError.userTokenExpired.subTitle), delay: 0.5)

        case .tooManyRequests:
            
            HUD.flash(.labeledError(title: AuthError.tooManyRequests.title,
                                    subtitle: AuthError.tooManyRequests.subTitle))

        case .appNotAuthorized:
            
            HUD.flash(.labeledError(title: AuthError.appNotAuthorized.title,
                subtitle: AuthError.appNotAuthorized.subTitle), delay: 0.5)

        case .keychainError:
            
            HUD.flash(.labeledError(title: AuthError.keychainError.title,
                subtitle: AuthError.keychainError.subTitle), delay: 0.5)

        case .internalError:
            
            HUD.flash(.labeledError(title: AuthError.internalError.title,
                subtitle: AuthError.internalError.subTitle), delay: 0.5)

        // SignIn Error
        case .invalidEmail:
            
            HUD.flash(.labeledError(title: AuthError.invalidEmail.title,
                subtitle: AuthError.invalidEmail.subTitle), delay: 0.5)

        case .operationNotAllowed:
            
            HUD.flash(.labeledError(title: AuthError.operationNotAllowed.title,
                subtitle: AuthError.operationNotAllowed.subTitle), delay: 0.5)

        case .userDisabled:
            
            HUD.flash(.labeledError(title: AuthError.userDisabled.title,
                subtitle: AuthError.userDisabled.subTitle), delay: 0.5)

        case .wrongPassword:
            
            HUD.flash(.labeledError(title: AuthError.wrongPassword.title,
                subtitle: AuthError.wrongPassword.subTitle), delay: 0.5)

        // SignUp Error
        case .emailAlreadyInUse:
            
            HUD.flash(.labeledError(title: AuthError.emailAlreadyInUse.title,
                subtitle: AuthError.emailAlreadyInUse.subTitle), delay: 0.5)

        case .weakPassword:
            
            HUD.flash(.labeledError(title: AuthError.weakPassword.title,
                subtitle: AuthError.weakPassword.subTitle), delay: 0.5)

        default:
            
            HUD.flash(.labeledError(title: AuthError.defaultError.title,
                subtitle: AuthError.defaultError.subTitle), delay: 0.5)
            
        }
        
    }
    
}
