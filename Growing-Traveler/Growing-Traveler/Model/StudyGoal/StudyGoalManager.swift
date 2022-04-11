//
//  StudyGoalManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/11.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class StudyGoalManager {
    
    // 上傳 新建的學習計劃 至 Firebase Firestore
    let database = Firestore.firestore().collection("studyGoal")
    
    func addData(studyGoal: StudyGoal) {
        
        do {
            
            let documentID = database.document().documentID
            
            try database.document(documentID).setData(from: studyGoal)
            
        } catch {
            
            print(error)
            
        }
    }
    
    // 取得 所有的學習計劃 至 StudyFoalViewController
    func fetchData(completion: @escaping (Result<[StudyGoal]>) -> Void) {
        
        database.order(by: "studyPeriod", descending: false)
            .getDocuments { snapshot, error in
            
            var studyGoals: [StudyGoal] = []
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let studyGoal = try document.data(as: StudyGoal.self, decoder: Firestore.Decoder()) {
                        
                        studyGoals.append(studyGoal)
                        
                        completion(Result.success(studyGoals))
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))
                    
                }
                
            }
                
        }
        
    }
    
    // 修改 選取的學習計劃 至 Firebase Firestore
    
    // 刪除 選取的學習計劃 至 Firebase Firestore
    
}
