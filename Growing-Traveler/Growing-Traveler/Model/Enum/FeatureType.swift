//
//  FeatureType.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum FeatureType {
    
    case mandate
    
    case analysis
    
    case release
    
    case license
    
    var title: String {
        
        switch self {
            
        case .mandate: return "學習成就"
            
        case .analysis: return "學習分析"
            
        case .release: return "發佈文章紀錄"
            
        case .license: return "個人認證"
            
        }
        
    }
    
}
