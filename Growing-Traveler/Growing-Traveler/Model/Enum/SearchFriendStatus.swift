//
//  SearchFriendStatus.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum SearchFriendStatus {
    
    case yourInfo
    
    case yourself
    
    case blocked
    
    case friendship
    
    case invitaion
    
    case applied
    
    case noSearch
    
    case noRelation
    
    case deleteAccount
    
    var title: String {
        
        switch self {
            
        case .yourInfo: return "你自己的帳號"
            
        case .yourself: return "不可加入自己！"
            
        case .blocked: return "你已封鎖該使用者！"
            
        case .friendship: return "你們已經是好友了！"
            
        case .invitaion: return "你已發送好友邀請，請等待對方同意！"
            
        case .applied: return "對方發出好友邀請給你！"
            
        case .noSearch: return "沒有該使用者的資料！請重新搜尋！"
            
        case .noRelation: return "你們還不是朋友，點擊按鈕發送好友邀請！"
            
        case .deleteAccount: return "此帳戶已刪除，無法加為好友！"
            
        }
        
    }
    
}
