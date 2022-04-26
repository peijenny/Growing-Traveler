//
//  UserManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserManager {
    
    let database = Firestore.firestore().collection("user")
    
    func fetchData(completion: @escaping (Result<UserInfo>) -> Void) {
        
        if userID != "" {
            
            database.whereField("userID", isEqualTo: userID).addSnapshotListener { snapshot, error in
                
                guard let snapshot = snapshot else {
                    
                    print("Error fetching document: \(error!)")
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                let document = snapshot.documents[0]
                    
                do {
                    
                    if let user = try document.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                        
                        completion(Result.success(user))
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
        }
        
    }
    
    func updateData(user: UserInfo) {
        
        do {
            
            if userID != "" {
                
                // 修改 成就數值
                try database.document(userID).setData(from: user, merge: true)
                
            }
            
        } catch {

            print(error)

        }
        
    }
    
    func addData(user: UserInfo) {
        
        do {
            
            if userID != "" {
                
                // 修改 成就數值
                try database.document(user.userID).setData(from: user, merge: true)
                
            }
            
        } catch {

            print(error)

        }
        
    }
    
}
