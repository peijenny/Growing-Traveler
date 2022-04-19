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
    
    // 取得好友名單 (聊天頁使用)，只需取得屬於本人的資料
    func fetchFriendListData(completion: @escaping (Result<Friend>) -> Void) {
        
        database.collection("friend")
        .whereField("userID", isEqualTo: userID)
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
    
}
