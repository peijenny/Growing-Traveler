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
    
    var title: String {
        
        switch self {
            
        case .appNotAuthorized: return "網路錯誤！"
            
        case .networkError: return "未找到此帳戶！"
            
        case .userNotFound: return "Token 過期！"
            
        case .userTokenExpired: return "登入次數頻繁！"
            
        case .tooManyRequests: return "App 無權使用 API！"
            
        case .keychainError: return "App 金鑰錯誤！"
            
        case .internalError: return "App 內部錯誤！"
            
        case .invalidEmail: return "Email 格式錯誤！"
            
        case .operationNotAllowed: return "Email 未註冊！"
            
        case .userDisabled: return "此帳號已被封鎖！"
            
        case .wrongPassword: return "登入密碼錯誤！"
            
        case .emailAlreadyInUse: return "Email 已被註冊！"
            
        case .weakPassword: return "密碼太弱！"
            
        }
        
    }
    
    var subTitle: String {
        
        switch self {
            
        case .appNotAuthorized: return "請重新登入"
            
        case .networkError: return "請確認帳號是否正確"
            
        case .userNotFound: return "請重新登入"
            
        case .userTokenExpired: return "請稍後再登入"
            
        case .tooManyRequests: return "請稍後再登入"
            
        case .keychainError: return "此帳號已被封鎖！"
            
        case .internalError: return ""
            
        case .invalidEmail: return ""
            
        case .operationNotAllowed: return ""
            
        case .userDisabled: return ""
            
        case .wrongPassword: return ""
            
        case .emailAlreadyInUse: return ""
            
        case .weakPassword: return "請使用別的密碼"
            
        }
        
    }
    
}

class ErrorManager {
    
    func handleAuthError(errorCode: AuthErrorCode) {
        
        switch errorCode {

        case .networkError:
            
            HUD.flash(.labeledError(title: AuthError.networkError.title,
                                    subtitle: AuthError.networkError.subTitle))
            
        case .userNotFound:
            
            HUD.flash(.labeledError(title: AuthError.userNotFound.title,
                                    subtitle: AuthError.userNotFound.subTitle))

        case .userTokenExpired:
            
            HUD.flash(.labeledError(title: AuthError.userTokenExpired.title,
                                    subtitle: AuthError.userTokenExpired.subTitle))

        case .tooManyRequests:
            
            HUD.flash(.labeledError(title: AuthError.tooManyRequests.title,
                                    subtitle: AuthError.tooManyRequests.subTitle))

        case .appNotAuthorized:
            
            HUD.flash(.labeledError(title: AuthError.appNotAuthorized.title,
                                    subtitle: AuthError.appNotAuthorized.subTitle))

        case .keychainError:
            
            HUD.flash(.labeledError(title: AuthError.keychainError.title,
                                    subtitle: AuthError.keychainError.subTitle))

        case .internalError:
            
            HUD.flash(.labeledError(title: AuthError.internalError.title,
                                    subtitle: AuthError.internalError.subTitle))

        // SignIn Error
        case .invalidEmail:
            
            HUD.flash(.labeledError(title: AuthError.invalidEmail.title,
                                    subtitle: AuthError.invalidEmail.subTitle))

        case .operationNotAllowed:
            
            HUD.flash(.labeledError(title: AuthError.operationNotAllowed.title,
                                    subtitle: AuthError.operationNotAllowed.subTitle))

        case .userDisabled:
            
            HUD.flash(.labeledError(title: AuthError.userDisabled.title,
                                    subtitle: AuthError.userDisabled.subTitle))

        case .wrongPassword:
            
            HUD.flash(.labeledError(title: AuthError.wrongPassword.title,
                                    subtitle: AuthError.wrongPassword.subTitle))

        // SignUp Error
        case .emailAlreadyInUse:
            
            HUD.flash(.labeledError(title: AuthError.emailAlreadyInUse.title,
                                    subtitle: AuthError.emailAlreadyInUse.subTitle))

        case .weakPassword:
            
            HUD.flash(.labeledError(title: AuthError.weakPassword.title,
                                    subtitle: AuthError.weakPassword.subTitle))

        default: break
            
        }
        
    }
    
}
