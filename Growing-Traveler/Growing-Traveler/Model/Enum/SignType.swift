//
//  SignType.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum SignType {
    
    case signIn
    
    case signUp
    
    var title: String {
        
        switch self {
            
        case .signIn: return "登入"
            
        case .signUp: return "註冊"
            
        }
        
    }
    
}
