//
//  ReportManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/13.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import PKHUD

class ReportManager {
    
    let database = Firestore.firestore().collection("report")
    
    func addReportData(reportContent: ReportContent) {
        
        do {
            
            try database.document(reportContent.reportID).setData(from: reportContent, merge: true)
            
        } catch {

            print(error)
            
            HUD.flash(.labeledError(title: "檢舉失敗！", subtitle: "請稍後再試"), delay: 0.5)

        }
        
    }
    
}
