//
//  StatusType.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum StatusType: Int, CaseIterable {
    
    case pending = 0
    
    case running = 1
    
    case finished = 2
    
    var title: String {
        
        switch self {
            
        case .pending: return "待處理"
            
        case .running: return "處理中"
            
        case .finished: return "已處理"
            
        }
        
    }
    
}
