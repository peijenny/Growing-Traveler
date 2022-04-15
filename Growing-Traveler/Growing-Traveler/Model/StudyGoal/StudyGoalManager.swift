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

let userID = "TESTUSERID"

class StudyGoalManager {
    
    let database = Firestore.firestore().collection("studyGoal")
    
    // 監聽 即時修改的學習計劃 至 Firebase Firestore
    func listenData(completion: @escaping (Result<[StudyGoal]>) -> Void) {
        
        database.addSnapshotListener { snapshot, error in
            
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
    
    // 上傳 新建的學習計劃 至 Firebase Firestore
    func addData(studyGoal: StudyGoal) {
        
        do {
            
            try database.document(studyGoal.id).setData(from: studyGoal)
            
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
    func updateData(studyGoal: StudyGoal) {
        
        do {

            try database.document(studyGoal.id).setData(from: studyGoal, merge: true)

        } catch {

            print(error)

        }

    }
    
    // 刪除 選取的學習計劃 至 Firebase Firestore
    
    func deleteData(studyGoal: StudyGoal) {
        
        database.document(studyGoal.id).delete { error in
            
            if let error = error {
                
                print(error)
                
            } else {
                
                print("Success")
            }
            
        }
        
    }
    
}
