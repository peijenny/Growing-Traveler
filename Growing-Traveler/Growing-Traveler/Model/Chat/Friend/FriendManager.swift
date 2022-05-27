//
//  FriendManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FriendManager {
    
    let database = Firestore.firestore()
    
    func listenFriendInfoData(completion: @escaping (Result<[UserInfo]>) -> Void) {
        
        database.collection("user").addSnapshotListener { snapshot, error in
            
            var users: [UserInfo] = []
            
            guard let snapshot = snapshot else {
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let user = try document.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                        
                        users.append(user)
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
            completion(Result.success(users))
            
        }
        
    }
    
    func fetchFriendInfoData(friendList: [String], completion: @escaping (Result<[UserInfo]>) -> Void) {
        
        var friendsInfo: [UserInfo] = []
        
        for index in 0..<friendList.count {
            
            database.collection("user").document(friendList[index])
            .getDocument { snapshot, error in
                
                guard let snapshot = snapshot else {
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                do {
                    
                    if let friendInfo = try snapshot.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                        
                        friendsInfo.append(friendInfo)
                        
                        completion(Result.success(friendsInfo))
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
        }
        
    }
    
    func listenFriendListData(fetchUserID: String, completion: @escaping (Result<Friend>) -> Void) {
        
        if !fetchUserID.isEmpty {
         
            database.collection("friend").whereField("userID", isEqualTo: fetchUserID)
            .addSnapshotListener { snapshot, error in
            
                guard let snapshot = snapshot else {
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                let document = snapshot.documents[0]
                    
                do {
                    
                    if let friend = try document.data(as: Friend.self, decoder: Firestore.Decoder()) {
                        
                        completion(Result.success(friend))
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))
                    
                }
                    
            }
            
        }
        
    }
    
    func fetchFriendListData(fetchUserID: String, completion: @escaping (Result<Friend>) -> Void) {
        
        if !fetchUserID.isEmpty {
         
            database.collection("friend").whereField("userID", isEqualTo: fetchUserID)
            .getDocuments { snapshot, error in
            
                guard let snapshot = snapshot else {
                    
                    print("Error fetching document: \(error!)")
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                let document = snapshot.documents[0]
                    
                do {
                    
                    if let friend = try document.data(as: Friend.self, decoder: Firestore.Decoder()) {
                        
                        completion(Result.success(friend))
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))
                    
                }
                    
            }
            
        }
        
    }
    
    func addFriendData(bothSides: BothSides, confirmType: String) {
        
        let ownChat = Chat(friendID: bothSides.other.userID, friendName: bothSides.other.userName, messageContent: [])

        let otherChat = Chat(friendID: bothSides.owner.userID, friendName: bothSides.owner.userName, messageContent: [])
        
        do {
            
            // MARK: - modify friend status
            try database.collection("friend").document(bothSides.owner.userID)
                .setData(from: bothSides.owner, merge: true)
            
            try database.collection("friend").document(bothSides.other.userID)
                .setData(from: bothSides.other, merge: false)
            
            // MARK: - add chat room
            if confirmType == ConfirmType.agree.title {
                
                try database.collection("friend").document(bothSides.owner.userID).collection("message")
                    .document(bothSides.other.userID).setData(from: ownChat, merge: true)
                
                try database.collection("friend").document(bothSides.other.userID).collection("message")
                    .document(bothSides.owner.userID).setData(from: otherChat, merge: true)
                
            }
            
        } catch {
            
            HandleResult.modifyFriendStatusFailed.messageHUD
            
        }
        
    }
    
    func updateFriendList(friend: Friend) {
        
        do {
            
            try database.collection("friend").document(friend.userID).setData(from: friend, merge: true)
            
        } catch {
            
            HandleResult.updateDataFailed.messageHUD

        }
        
    }
    
}
