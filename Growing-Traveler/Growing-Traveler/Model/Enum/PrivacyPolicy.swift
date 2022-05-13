//
//  PrivacyPolicy.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum PrivacyPolicy {
    
    case privacyPolicy
    
    case eula
    
    var title: String {
        
        switch self {
            
        case .privacyPolicy: return "隱私權政策"
            
        case .eula: return "最終用戶許可協議"
            
        }
        
    }
    
}
