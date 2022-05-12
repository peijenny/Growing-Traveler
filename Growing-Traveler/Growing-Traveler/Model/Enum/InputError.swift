//
//  InputError.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/12.
//

import UIKit

enum InputError {
    
    case titleEmpty
    
    case startDateEmpty
    
    case endDateEmpty
    
    case studyTimeEmpty
    
    case categoryEmpty
    
    case studyItemEmpty
    
    case contentEmpty
    
    case startDatereLativelyLate
    
    var title: String {
        
        switch self {
            
        case .titleEmpty: return "標題不可為空！"
            
        case .startDateEmpty: return "尚未選擇開始日期！"
            
        case .endDateEmpty: return "尚未選擇結束日期！"
            
        case .studyTimeEmpty: return "請選擇項目的學習時間！"
            
        case .categoryEmpty: return "尚未選擇分類標籤！"
            
        case .studyItemEmpty: return "學習項目不可為空！"
            
        case .contentEmpty: return "內容輸入不可為空！"
            
        case .startDatereLativelyLate: return "開始日期大於結束日期！"
            
        }
        
    }
    
}
