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
    
    func fetchFriendEmailData(completion: @escaping (Result<[User]>) -> Void) {
        
        database.collection("user").addSnapshotListener { snapshot, error in
            
            var users: [User] = []
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                        
                        users.append(user)
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
            completion(Result.success(users))
            
        }
        
    }
    
    // 取得好友名單 (聊天頁使用)，只需取得屬於本人的資料
    func fetchFriendListData(fetchUserID: String, completion: @escaping (Result<Friend>) -> Void) {
        
        database.collection("friend")
        .whereField("userID", isEqualTo: fetchUserID)
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
                
                print(error)
                
                completion(Result.failure(error))
                
            }
                
        }
        
    }
    
    // 取得好友姓名
    func fetchFriendInfoData(friendList: [String], completion: @escaping (Result<[User]>) -> Void) {
        
        var friendsInfo: [User] = []
        
        for index in 0..<friendList.count {
            
            database
            .collection("user")
            .whereField("userID", isEqualTo: friendList[index])
            .getDocuments { snapshot, error in
                
                guard let snapshot = snapshot else {
                    
                    print("Error fetching document: \(error!)")
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                let document = snapshot.documents[0]
                    
                do {
                    
                    if let friendInfo = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                        
                        friendsInfo.append(friendInfo)
                        
                        completion(Result.success(friendsInfo))
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
        }
        
    }
    
    func addFriendData(bothSides: BothSides, confirmType: String) {
        
        let ownChat = Chat(friendID: bothSides.other.userID, messageContent: [])

        let otherChat = Chat(friendID: bothSides.owner.userID, messageContent: [])
        
        do {
            
            // MARK: - 修改好友狀態
            // 修改自己的好友狀態 Document
            try database.collection("friend").document(bothSides.owner.userID)
                .setData(from: bothSides.owner, merge: true)
            
            // 修改對方的好友狀態 Document
            try database.collection("friend").document(bothSides.other.userID)
                .setData(from: bothSides.other, merge: false)
            
            // MARK: - 加入聊天室
            if confirmType == ConfirmType.agree.title {
                
                // 修改自己的聊天室 Document
                try database.collection("friend").document(bothSides.owner.userID).collection("message")
                    .document(bothSides.other.userID).setData(from: ownChat, merge: true)
                
                // 修改對方的聊天室 Document
                try database.collection("friend").document(bothSides.other.userID).collection("message")
                    .document(bothSides.owner.userID).setData(from: otherChat, merge: true)
                
            }
            
        } catch {

            print(error)

        }
        
    }
    
}
