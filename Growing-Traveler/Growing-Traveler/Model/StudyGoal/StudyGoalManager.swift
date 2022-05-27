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
    
    let database = Firestore.firestore().collection("studyGoal")
    
    func listenStudyGoals(completion: @escaping (Result<[StudyGoal]>) -> Void) { //
        
        if !KeyToken().userID.isEmpty {
         
            database.whereField("userID", isEqualTo: KeyToken().userID).addSnapshotListener { snapshot, error in
                
                var studyGoals: [StudyGoal] = []
                
                guard let snapshot = snapshot else {
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                for document in snapshot.documents {
                    
                    do {
                        
                        if let studyGoal = try document.data(as: StudyGoal.self, decoder: Firestore.Decoder()) {
                            
                            studyGoals.append(studyGoal)
                            
                        }
                        
                    } catch {
                        
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

    func fetchStudyGoals(completion: @escaping (Result<[StudyGoal]>) -> Void) {
        
        if !KeyToken().userID.isEmpty {
            
            database.whereField("userID", isEqualTo: KeyToken().userID).getDocuments { snapshot, error in
                
                var studyGoals: [StudyGoal] = []
                
                guard let snapshot = snapshot else {
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                for document in snapshot.documents {
                    
                    do {
                        
                        if let studyGoal = try document.data(as: StudyGoal.self, decoder: Firestore.Decoder()) {
                            
                            studyGoals.append(studyGoal)
                            
                        }
                        
                    } catch {
                        
                        completion(Result.failure(error))
                        
                    }
                    
                }
                    
                completion(Result.success(studyGoals))
                    
            }
            
        }
        
    }
    
    func addStudyGoal(studyGoal: StudyGoal) {
        
        do {
            
            try database.document(studyGoal.id).setData(from: studyGoal)
            
        } catch {
            
            HandleResult.addDataFailed.messageHUD
            
        }
        
    }
    
    func updateStudyGoal(studyGoal: StudyGoal) {
        
        do {

            try database.document(studyGoal.id).setData(from: studyGoal, merge: true)

        } catch {
            
            HandleResult.updateDataFailed.messageHUD
            
        }

    }

    func deleteStudyGoal(studyGoal: StudyGoal) {
        
        database.document(studyGoal.id).delete { error in
            
            if error != nil {
                
                HandleResult.deleteDataFailed.messageHUD
                
            } else {
                
                HandleResult.deleteDataSuccessed.messageHUD
                
            }
            
        }
        
    }
    
}
