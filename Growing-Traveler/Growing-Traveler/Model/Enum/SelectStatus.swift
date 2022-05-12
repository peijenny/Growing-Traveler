//
//  SelectStatus.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum SelectStatus {
    
    case add
    
    case modify
    
    var title: String {
        
        switch self {
            
        case .add: return "add"
            
        case .modify: return "modify"
            
        }
        
    }
    
}
