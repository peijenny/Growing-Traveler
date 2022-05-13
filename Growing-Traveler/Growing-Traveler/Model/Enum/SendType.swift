//
//  SendType.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum SendType {
    
    case image
    
    case string
    
    case articleID
    
    case noteID
    
    var title: String {
        
        switch self {
            
        case .image: return "image"
            
        case .string: return "string"
            
        case .articleID: return "articleID"
            
        case .noteID: return "noteID"
            
        }
        
    }
    
}
