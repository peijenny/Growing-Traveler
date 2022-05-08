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
import PKHUD

class ChatRoomManager {
    
    let database = Firestore.firestore().collection("friend")
    
    func fetchFriendsChatData(completion: @escaping (Result<[Chat]>) -> Void) {
        
        var friendsChat: [Chat] = []
        
        if userID != "" {
            
            database.document(userID).collection("message")
            .getDocuments { snapshot, error in
                
                guard let snapshot = snapshot else {
                    
                    print("Error fetching document: \(error!)")
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                for document in snapshot.documents {
                    
                    do {
                        
                        if let friendChat = try document.data(as: Chat.self, decoder: Firestore.Decoder()) {
                            
                            friendsChat.append(friendChat)
                            
                        }
                        
                    } catch {
                        
                        print(error)
                        
                        completion(Result.failure(error))
                        
                    }
                    
                }
                
                completion(Result.success(friendsChat))
                
            }
            
        }
        
    }

    func fetchData(friendID: String, completion: @escaping (Result<Chat>) -> Void) {
        
        if userID != "" {
            
            database.document(userID).collection("message")
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
    
    func addData(userName: String, chat: Chat) {
        
        var friendChat = chat
        
        friendChat.friendID = userID
        
        friendChat.friendName = userName
        
        do {
            
            if userID != "" {
                
                // 修改自己的 Document
                try database.document(userID).collection("message")
                    .document(chat.friendID).setData(from: chat, merge: true)
                
                // 修改朋友的 Document
                try database.document(chat.friendID).collection("message")
                    .document(userID).setData(from: friendChat, merge: true)
                
            }

        } catch {

            print(error)
            
            HUD.flash(.labeledError(title: "訊息傳送失敗！", subtitle: "請稍後再試"), delay: 0.5)

        }
        
    }
    
}
