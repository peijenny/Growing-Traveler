//
//  MandateType.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum MandateType {
    
    case login
    
    case friends
    
    case completion
    
    var title: String {
        
        switch self {
            
        case .login: return "login"
            
        case .friends: return "friends"
            
        case .completion: return "completion"
            
        }
        
    }
    
}
