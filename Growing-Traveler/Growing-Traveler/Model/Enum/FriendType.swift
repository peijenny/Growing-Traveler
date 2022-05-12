//
//  FriendType.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum FriendType {
    
    case friend
    
    case blockade
    
    case apply
    
    var title: String {
        
        switch self {
            
        case .friend: return "好友列表"
            
        case .blockade: return "封鎖列表"
            
        case .apply: return "發出邀請列表"
            
        }
        
    }
    
}
