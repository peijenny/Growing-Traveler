//
//  ConfirmType.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum ConfirmType {
    
    case agree
    
    case refuse
    
    case apply
    
    var title: String {
        
        switch self {
            
        case .agree: return "同意"
            
        case .refuse: return "取消"
            
        case .apply: return "申請"
            
        }
        
    }
    
}
