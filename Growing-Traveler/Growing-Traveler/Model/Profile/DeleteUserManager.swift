//
//  DeleteUserManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class DeleteUserManager {
    
    let database = Firestore.firestore()
    
    // MARK: - 要刪除帳號的使用者本身
    // 按順序刪除: StudyGoal -> AllForumArticle -> ArticleMessage -> ForumArticle -> FriendList -> UserInfo
    
//    var user: UserInfo? // 使用者資料 (1筆)
//
//    var studyGoals: [StudyGoal] = []  // 使用者建立的學習目標 (多筆)
//
//    var friendList: Friend? // 使用者的 Friend 資料 (1筆)
//
//    var forumArticles: [ForumArticle] = [] // 使用者發布的 Forum 文章 (多筆)
//
//    var deleteArticleMessages: [DeleteArticle] = [] // 使用者於 Forum 文章下的留言 (多筆)
//
//    var allForumArticles: [ForumArticle] = [] // 所有使用者發佈的文章
    
    // 其他使用者不用刪除聊天記錄 (在 selectRowAt 去判斷該用戶是否被刪除)
    // 其他使用者的 FriendList 還會有那個好友嗎?
    // 其他使用者的 Friend 其他列表，也應該刪掉該名好友才行！
    
    func fetchData() {
        
//        // 取 User 建立的所有學習計畫
//        fetchStudyGoalsData()
//
//        // 取所有 User 建立的討論區文章
//        fetchAllArticleMessagesData()
//
//        // 取 User 建立的所有討論區文章
//        fetchForumArticlesData()
//
//        // 取 User 朋友的資料
//        fetchFriendListData()
//
//        // 取 User 個人的資料
//        fetchUserInfoData()

//        let group = DispatchGroup()
//
//        let queueTasks = [
//
//            DispatchQueue(label: "getStudyGoals"),
//            DispatchQueue(label: "getAllArticleMessages"),
//            DispatchQueue(label: "getForumArticles"),
//            DispatchQueue(label: "getFriendList"),
//            DispatchQueue(label: "getUserInfo")
//
//        ]
//
//        group.enter()
//
//        queueTasks[0].async(group: group, qos: .default) {
//
//            // 取 User 建立的所有學習計畫
//            self.fetchStudyGoalsData()
//
//            group.leave()
//
//        }
//
//        group.enter()
//
//        queueTasks[1].async(group: group, qos: .default) {
//
//            // 取所有 User 建立的討論區文章
//            self.fetchAllArticleMessagesData()
//
//            group.leave()
//
//        }
//
//        group.enter()
//
//        queueTasks[2].async(group: group, qos: .default) {
//
//            // 取 User 建立的所有討論區文章
//            self.fetchForumArticlesData()
//
//            group.leave()
//
//        }
//
//        group.enter()
//
//        queueTasks[3].async(group: group, qos: .default) {
//
//            // 取 User 朋友的資料
//            self.fetchFriendListData()
//
//            group.leave()
//
//        }
//
//        group.enter()
//
//        queueTasks[4].async(group: group, qos: .default) {
//
//            // 取 User 個人的資料
//            self.fetchUserInfoData()
//
//            group.leave()
//
//        }
//
//        group.notify(queue: .main) {
//
//            print("Fetch Data Done.")
//
//            userID = ""
//
//        }
        
    }
    
    func deleteStudyGoalsData(studyGoals: [StudyGoal]) {

        for index in 0..<studyGoals.count {
            
            database.collection("studyGoal").document(studyGoals[index].id).delete { error in
                
                if let error = error {
                    
                    print(error)
                    
                } else {
                    
                    print("Success")
                }
                
            }
            
        }

    }
    
    func deleteForumArticlesData(forumArticles: [ForumArticle]) {

        for index in 0..<forumArticles.count {
            
            database.collection("forum").document(forumArticles[index].id).delete { error in
                
                if let error = error {
                    
                    print(error)
                    
                } else {
                    
                    print("Success")
                }
                
            }
            
        }
        
    }
    
    func deleteAllArticleMessagesData(deleteArticleMessages: [DeleteArticle]) {
        
        for index in 0..<deleteArticleMessages.count {
            
            for itemIndex in 0..<deleteArticleMessages[index].articleMessage.count {
                
                database.collection("forum").document(deleteArticleMessages[index].articleID).collection("message")
                .document("\(Int(deleteArticleMessages[index].articleMessage[itemIndex].createTime))")
                .delete { error in
                    
                    if let error = error {
                        
                        print(error)
                        
                    } else {
                        
                        print("Success")
                    }
                    
                }
                
            }

        }
        
    }
    
    func deleteFriendListData(deleteUserID: String) {

        database.collection("friend").document(deleteUserID).delete { error in
            
            if let error = error {
                
                print(error)
                
            } else {
                
                print("Success")
            }
            
        }
        
    }
    
    func deleteUserInfoData(deleteUserID: String) {

        database.collection("user").document(deleteUserID).delete { error in
            
            if let error = error {
                
                print(error)
                
            } else {
                
                print("Success")
                
//                userID = ""
//
            }
            
        }
        
    }
    
    func fetchStudyGoalsData(completion: @escaping (Result<[StudyGoal]>) -> Void) {

        database.collection("studyGoal")
        .whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in
            
            var studyGoals: [StudyGoal] = []
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let studyGoal = try document.data(as: StudyGoal.self, decoder: Firestore.Decoder()) {
                        
                        studyGoals.append(studyGoal)
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))

                }
                
            }
            
            completion(Result.success(studyGoals))
            
        }
        
    }
    
    func fetchForumArticlesData(completion: @escaping (Result<[ForumArticle]>) -> Void) {
        
        var forumArticles: [ForumArticle] = []

        database.collection("forum")
        .whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in

            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")

                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let forumArticle = try document.data(as: ForumArticle.self, decoder: Firestore.Decoder()) {
                        
                        forumArticles.append(forumArticle)
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))

                }
                
            }
            
            completion(Result.success(forumArticles))

        }
        
    }
    
    func fetchFriendListData(completion: @escaping (Result<Friend>) -> Void) {
        
        database.collection("friend")
        .document(userID).getDocument { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                return
                
            }
                
            do {
                
                if let friend = try snapshot.data(as: Friend.self, decoder: Firestore.Decoder()) {
                    
                    completion(Result.success(friend))
                    
                }
                
            } catch {
                
                print(error)
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
    
    func fetchUserInfoData(completion: @escaping (Result<UserInfo>) -> Void) {
        
        database.collection("user")
        .document(userID).getDocument { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")

                return
                
            }
                
            do {
                
                if let user = try snapshot.data(as: UserInfo.self, decoder: Firestore.Decoder()) {

                    completion(Result.success(user))
                    
                }
                
            } catch {
                
                print(error)
                
                completion(Result.failure(error))
 
            }
            
        }
        
    }
    
    func fetchArticleMessagesData(allForumArticles: [ForumArticle], completion: @escaping (Result<[DeleteArticle]>) -> Void) {
        
        var deleteArticleMessages: [DeleteArticle] = []
        
        for index in 0..<allForumArticles.count {
            
            database.document(allForumArticles[index].id).collection("message")
            .getDocuments { snapshot, error in

                var articleMessages: [ArticleMessage] = []

                guard let snapshot = snapshot else {

                    print("Error fetching document: \(error!)")

                    return

                }

                for document in snapshot.documents {

                    do {

                        if let articleMessage = try document.data(
                            as: ArticleMessage.self, decoder: Firestore.Decoder()) {

                            articleMessages.append(articleMessage)

                        }

                    } catch {

                        print(error)

                        completion(Result.failure(error))

                    }

                }

                deleteArticleMessages.append(DeleteArticle(
                    articleID: allForumArticles[index].id, articleMessage: articleMessages))

            }
            
            completion(Result.success(deleteArticleMessages))

        }
        
    }
    
    func fetchAllForumArticlesData(completion: @escaping (Result<[ForumArticle]>) -> Void) {

        var allForumArticles: [ForumArticle] = []
        
        database.collection("forum").getDocuments { snapshot, error in

            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let forumArticle = try document.data(as: ForumArticle.self, decoder: Firestore.Decoder()) {
                        
                        allForumArticles.append(forumArticle)
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
            completion(Result.success(allForumArticles))

        }
        
    }
    
}
