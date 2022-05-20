//
//  HandleResultManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/20.
//

import UIKit
import PKHUD

enum HandleResult {
    
    case readDataFailed
    
    case reportFailed
    
    case addDataFailed
    
    case updateDataFailed
    
    case deleteDataFailed
    
    case modifyFriendStatusFailed
    
    case sendMassageFailed
    
    case deleteDataSuccessed
    
    case finishedStudyItem
    
    var messageHUD: Void {
        
        switch self {
            
        case .readDataFailed:
            
            HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .reportFailed:
            
            HUD.flash(.labeledError(title: "檢舉失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .addDataFailed:
            
            HUD.flash(.labeledError(title: "新增失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .updateDataFailed:
            
            HUD.flash(.labeledError(title: "修改失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .deleteDataFailed:
            
            HUD.flash(.labeledError(title: "刪除失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .modifyFriendStatusFailed:
            
            HUD.flash(.labeledError(title: "狀態修改失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .sendMassageFailed:
            
            HUD.flash(.labeledError(title: "訊息傳送失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        case .deleteDataSuccessed:
            
            HUD.flash(.labeledSuccess(title: "刪除成功！", subtitle: nil), delay: 0.5)
            
        case .finishedStudyItem:
            
            HUD.flash(.labeledSuccess(title: "學習項目完成！", subtitle: nil), delay: 0.5)
            
        }
    }
    
}

//class HandleResultManager {
//
////    func readDataFailed() {
////
////        HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
////
////    }
////
////    func reportFailed() {
////
////        HUD.flash(.labeledError(title: "檢舉失敗！", subtitle: "請稍後再試"), delay: 0.5)
////
////    }
////
////    func addDataFailed() {
////
////        HUD.flash(.labeledError(title: "新增失敗！", subtitle: "請稍後再試"), delay: 0.5)
////
////    }
////
////    func updateDataFailed() {
////
////        HUD.flash(.labeledError(title: "修改失敗！", subtitle: "請稍後再試"), delay: 0.5)
////
////    }
////
////    func deleteDataFailed() {
////
////        HUD.flash(.labeledError(title: "刪除失敗！", subtitle: "請稍後再試"), delay: 0.5)
////
////    }
////
////    func modifyFriendStatusFailed() {
////
////        HUD.flash(.labeledError(title: "狀態修改失敗！", subtitle: "請稍後再試"), delay: 0.5)
////
////    }
////
////    func sendMassageFailed() {
////
////        HUD.flash(.labeledError(title: "訊息傳送失敗！", subtitle: "請稍後再試"), delay: 0.5)
////
////    }
////
////    func deleteDataSuccessed() {
////
////        HUD.flash(.labeledSuccess(title: "刪除成功！", subtitle: nil), delay: 0.5)
////
////    }
////
////    func finishedStudyItem() {
////
////        HUD.flash(.labeledSuccess(title: "學習項目完成！", subtitle: nil))
////
////    }
//
//}
