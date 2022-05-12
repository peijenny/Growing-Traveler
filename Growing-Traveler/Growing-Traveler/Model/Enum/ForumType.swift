//
//  ForumType.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum ForumType {
    
    case essay
    
    case question
    
    case chat
    
    var title: String {
        
        switch self {
            
        case .essay: return "文章"
            
        case .question: return "問題"
            
        case .chat: return "閒聊"
            
        }
        
    }
    
    var word: String {
        
        switch self {
            
        case .essay: return "essay"
            
        case .question: return "question"
            
        case .chat: return "chat"
            
        }
        
    }
    
}
