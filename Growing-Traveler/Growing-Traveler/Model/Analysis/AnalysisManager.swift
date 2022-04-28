//
//  AnalysisManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class AnalysisManager {
    
    let database = Firestore.firestore()
    
    func fetchStudyData(completion: @escaping (Result<[StudyGoal]>) -> Void) {
        
        if userID != "" {
            
            database.collection("studyGoal")
                .whereField("userID", isEqualTo: userID)
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
    
    func fetchFeedbackData(completion: @escaping (Result<[Feedback]>) -> Void) {
        
        database.collection("feedback").getDocuments { snapshot, error in
            
            var feedbacks: [Feedback] = []
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let feedback = try document.data(as: Feedback.self, decoder: Firestore.Decoder()) {
                        
                        feedbacks.append(feedback)
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
            completion(Result.success(feedbacks))
        }
        
    }
    
}
