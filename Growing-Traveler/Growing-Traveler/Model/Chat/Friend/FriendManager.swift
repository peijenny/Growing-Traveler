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
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let user = try document.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                        
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
        
        if fetchUserID != "" {
         
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
        
    }
    
    // 取得好友姓名
    func fetchFriendInfoData(friendList: [String], completion: @escaping (Result<[UserInfo]>) -> Void) {
        
        var friendsInfo: [UserInfo] = []
        
        for index in 0..<friendList.count {
            
            database
            .collection("user").document(friendList[index])
            .getDocument { snapshot, error in
                
                guard let snapshot = snapshot else {
                    
                    print("Error fetching document: \(error!)")
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                do {
                    
                    if let friendInfo = try snapshot.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                        
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
        
        let ownChat = Chat(friendID: bothSides.other.userID, friendName: bothSides.other.userName, messageContent: [])

        let otherChat = Chat(friendID: bothSides.owner.userID, friendName: bothSides.owner.userName, messageContent: [])
        
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
    
    func addData(friend: Friend) {
        
        do {
            
            // 新增使用者帳號
            try database.collection("friend")
                .document(friend.userID).setData(from: friend, merge: true)
            
        } catch {

            print(error)

        }
        
    }
    
}
