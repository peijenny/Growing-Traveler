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
    
    // .collection("mandate")
    
    func addData(mandates: [Mandate]) {
        
        do {
            
            for index in 0..<mandates.count {
                
                try database.collection("user").document(userID)
                    .collection("mandate").document(mandates[index].mandateTitle)
                    .setData(from: mandates[index], merge: true)
                
            }
            
        } catch {
            
            print(error)
            
        }
        
    }

    func fetchMandateData(completion: @escaping (Result<[Mandate]>) -> Void) {
        
        database.collection("mandate").getDocuments { snapshot, error in
            
            var mandates: [Mandate] = []
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let mandate = try document.data(as: Mandate.self, decoder: Firestore.Decoder()) {
                        
                        mandates.append(mandate)
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
            completion(Result.success(mandates))
            
        }
        
    }
    
    func fetchOwnerData(completion: @escaping (Result<[Mandate]>) -> Void) {
        
        database.collection("user").document(userID)
            .collection("madate").addSnapshotListener { snapshot, error in
            
            var mandates: [Mandate] = []
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let mandate = try document.data(as: Mandate.self, decoder: Firestore.Decoder()) {
                        
                        mandates.append(mandate)
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
            completion(Result.success(mandates))
            
        }
        
    }
    
}
