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
import PKHUD

class StudyGoalManager {
    
    let database = Firestore.firestore().collection("studyGoal")
    
    // 監聽 即時修改的學習計劃 至 Firebase Firestore
    func listenData(completion: @escaping (Result<[StudyGoal]>) -> Void) { //
        
        if KeyToken().userID != "" {
         
            database.whereField("userID", isEqualTo: KeyToken().userID)
                .addSnapshotListener { snapshot, error in
                
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
                            
                        }
                        
                    } catch {
                        
                        print(error)
                        
                        completion(Result.failure(error))
                        
                    }
                    
                }
                
                studyGoals = studyGoals.sorted { (lhs, rhs) in
                    
                    return lhs.studyPeriod.endDate < rhs.studyPeriod.endDate
                    
                }
                
                completion(Result.success(studyGoals))
                
            }
            
        }
        
    }
    
    // 上傳 新建的學習計劃 至 Firebase Firestore
    func addData(studyGoal: StudyGoal) {
        
        do {
            
            try database.document(studyGoal.id).setData(from: studyGoal)
            
        } catch {
            
            print(error)
            
            HUD.flash(.labeledError(title: "新增失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        }
        
    }
    
    // 取得 所有的學習計劃 至 StudyFoalViewController
    func fetchData(completion: @escaping (Result<[StudyGoal]>) -> Void) {
        
        if KeyToken().userID != "" {
            
            database
                .whereField("userID", isEqualTo: KeyToken().userID)
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
                            
                        }
                        
                    } catch {
                        
                        print(error)
                        
                        completion(Result.failure(error))
                        
                    }
                    
                }
                    
                completion(Result.success(studyGoals))
                    
            }
            
        }
        
    }
    
    // 修改 選取的學習計劃 至 Firebase Firestore
    func updateData(studyGoal: StudyGoal) {
        
        do {

            try database.document(studyGoal.id).setData(from: studyGoal, merge: true)

        } catch {

            print(error)
            
            HUD.flash(.labeledError(title: "修改失敗！", subtitle: "請稍後再試"), delay: 0.5)

        }

    }
    
    // 刪除 選取的學習計劃 至 Firebase Firestore
    
    func deleteData(studyGoal: StudyGoal) {
        
        database.document(studyGoal.id).delete { error in
            
            if let error = error {
                
                print(error)
                
                HUD.flash(.labeledError(title: "刪除失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            } else {
                
                print("Success")
            }
            
        }
        
    }
    
}
