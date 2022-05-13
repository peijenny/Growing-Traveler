//
//  SelectDateType.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum SelectDateType {
    
    case startDate
    
    case endDate
    
    var title: String {
        
        switch self {
            
        case .startDate: return "start"
            
        case .endDate: return "end"
            
        }
        
    }
    
}
