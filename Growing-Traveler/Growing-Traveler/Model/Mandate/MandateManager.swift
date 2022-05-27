//
//  MandateManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class MandateManager {
    
    let database = Firestore.firestore()
    
    func addData(mandates: [Mandate]) {
        
        if !KeyToken().userID.isEmpty {
            
            do {
                
                for index in 0..<mandates.count {
                    
                    try database.collection("user").document(KeyToken().userID)
                        .collection("mandate").document(mandates[index].mandateTitle)
                        .setData(from: mandates[index], merge: true)
                    
                }
                
            } catch {
                
                HandleResult.addDataFailed.messageHUD
                
            }
            
        }
        
    }

    func fetchMandateData(completion: @escaping (Result<[Mandate]>) -> Void) {
        
        database.collection("mandate").getDocuments { snapshot, error in
            
            var mandates: [Mandate] = []
            
            guard let snapshot = snapshot else {
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let mandate = try document.data(as: Mandate.self, decoder: Firestore.Decoder()) {
                        
                        mandates.append(mandate)
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
            completion(Result.success(mandates))
            
        }
        
    }
    
    func fetchOwnerData(completion: @escaping (Result<[Mandate]>) -> Void) {
        
        if !KeyToken().userID.isEmpty {
            
            database.collection("user").document(KeyToken().userID)
                .collection("mandate").addSnapshotListener { snapshot, error in
                
                var mandates: [Mandate] = []
                
                guard let snapshot = snapshot else {
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                for document in snapshot.documents {
                    
                    do {
                        
                        if let mandate = try document.data(as: Mandate.self, decoder: Firestore.Decoder()) {
                            
                            mandates.append(mandate)
                            
                        }
                        
                    } catch {
                        
                        completion(Result.failure(error))
                        
                    }
                    
                }
                
                completion(Result.success(mandates))
                
            }
            
        }
        
    }
    
}
