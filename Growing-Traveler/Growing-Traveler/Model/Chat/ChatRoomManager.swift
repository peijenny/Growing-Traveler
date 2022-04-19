//
//  ChatRoomManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/18.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatRoomManager {
    
    let database = Firestore.firestore().collection("friend").document(userID).collection("message")
    
    func fetchData(friendID: String, completion: @escaping (Result<Chat>) -> Void) {
        
        database
        .whereField("friendID", isEqualTo: friendID)
        .addSnapshotListener { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            do {
                
                let document = snapshot.documents[0]
                
                if let chatMessage = try document.data(as: Chat.self, decoder: Firestore.Decoder()) {
                    
                    completion(Result.success(chatMessage))
                    
                }
                
            } catch {
                
                print(error)
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
    
}
