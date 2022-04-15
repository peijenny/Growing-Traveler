//
//  CategoryManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

enum Result<T> {
    
    case success(T)
    
    case failure(Error)
    
}

class CategoryManager {
    
    let categorys = Firestore.firestore().collection("category")
    
    func fetchData(completion: @escaping (Result<[Category]>) -> Void) {
        
        categorys
            .order(by: "items", descending: false)
            .getDocuments { snapshot, error in
            
            var categorys: [Category] = []
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let category = try document.data(as: Category.self, decoder: Firestore.Decoder()) {
                        
                        categorys.append(category)
                        
                        completion(Result.success(categorys))
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
        }
    }
}
