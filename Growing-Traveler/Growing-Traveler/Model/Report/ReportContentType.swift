//
//  CheckUserStatus.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/13.
//

import UIKit

enum BlockContentType {
    
    case user

    case chat
    
    case article
    
    case message
    
    var title: String {
        
        switch self {
            
        case .user: return "封鎖此帳號"
        
        case .chat: return "封鎖聊天內容"
            
        case .article: return "封鎖此文章"
            
        case .message: return "封鎖此留言"
            
        }
        
    }
    
}

enum ReportContentType {

    case chat
    
    case article
    
    case message
    
    var title: String {
        
        switch self {
        
        case .chat: return "聊天室內容檢舉"
            
        case .article: return "討論區文章檢舉"
            
        case .message: return "討論區留言檢舉"
            
        }
        
    }
    
}

struct ReportContent: Codable {
    
    var reportID: String
    
    var userID: String
    
    var reportedUserID: String
    
    var reportType: String
    
    var reportContent: String
    
    var createTime: TimeInterval
    
    var friendID: String?
    
    var articleID: String?
    
    var articleMessage: ArticleMessage?

}
