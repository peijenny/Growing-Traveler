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
    
    let database = Firestore.firestore().collection("friend")
    
    func fetchFriendsChatData(completion: @escaping (Result<[Chat]>) -> Void) {
        
        var friendsChat: [Chat] = []
        
        if !KeyToken().userID.isEmpty {
            
            database.document(KeyToken().userID).collection("message").getDocuments { snapshot, error in
                
                guard let snapshot = snapshot else {
                 
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                for document in snapshot.documents {
                    
                    do {
                        
                        if let friendChat = try document.data(as: Chat.self, decoder: Firestore.Decoder()) {
                            
                            friendsChat.append(friendChat)
                            
                        }
                        
                    } catch {
                        
                        completion(Result.failure(error))
                        
                    }
                    
                }
                
                completion(Result.success(friendsChat))
                
            }
            
        }
        
    }

    func fetchData(friendID: String, completion: @escaping (Result<Chat>) -> Void) {
        
        if !KeyToken().userID.isEmpty {
            
            database.document(KeyToken().userID).collection("message")
            .whereField("friendID", isEqualTo: friendID)
            .addSnapshotListener { snapshot, error in
                
                guard let snapshot = snapshot else {
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                do {
                    
                    let document = snapshot.documents[0]
                    
                    if let chatMessage = try document.data(as: Chat.self, decoder: Firestore.Decoder()) {
                        
                        completion(Result.success(chatMessage))
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
        }
        
    }
    
    func addData(userName: String, chat: Chat) {
        
        var friendChat = chat
        
        friendChat.friendID = KeyToken().userID
        
        friendChat.friendName = userName
        
        do {
            
            if !KeyToken().userID.isEmpty {
                
                // add message - self
                try database.document(KeyToken().userID).collection("message")
                    .document(chat.friendID).setData(from: chat, merge: true)
                
                // add message - friend
                try database.document(chat.friendID).collection("message")
                    .document(KeyToken().userID).setData(from: friendChat, merge: true)
                
            }

        } catch {
            
            HandleResult.sendMassageFailed.messageHUD
            
        }
        
    }
    
}
