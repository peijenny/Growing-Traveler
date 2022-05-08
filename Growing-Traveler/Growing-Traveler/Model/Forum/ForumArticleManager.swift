//
//  ForumArticleManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import PKHUD

class ForumArticleManager {
    
    let database = Firestore.firestore().collection("forum")
    
    // 監聽 討論區的文章 從 Firebase Firestore
    func listenData(completion: @escaping (Result<[ForumArticle]>) -> Void) {
        
        var forumArticles: [ForumArticle] = []
        
        let forumTypes: [String] = [
            ForumType.essay.title,
            ForumType.question.title,
            ForumType.chat.title
        ]

        for index in 0..<forumTypes.count {
            
            database
                .whereField("forumType", isEqualTo: forumTypes[index])
//                .whereField("userID", isNotEqualTo: "ve40GsMc8bVA7u99neqM3wxR7ev2")
                .order(by: "createTime", descending: true)
//                .limit(to: 5)
                .addSnapshotListener { snapshot, error in
                
                guard let snapshot = snapshot else {
                    
                    print("Error fetching document: \(error!)")
                    
                    completion(Result.failure(error!))
                    
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

    }
    
    // 上傳 新的論壇文章 至 Firebase Firestore
    func addData(forumArticle: ForumArticle) {
        
        do {
            
            try database.document(forumArticle.id).setData(from: forumArticle)
            
        } catch {
            
            print(error)
            
            HUD.flash(.labeledError(title: "新增失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        }
        
    }
    
    // 更新 論壇文章 至 Firebase Firestore
    func updateArticleData(forumArticle: ForumArticle) {
        
        do {
            
            try database.document(forumArticle.id).setData(from: forumArticle, merge: true)
            
        } catch {
            
            print(error)
            
            HUD.flash(.labeledError(title: "修改失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        }
        
    }
    
    // 取得 屬於論壇的所有文章 至 ArticleViewController
    func fetchData(forumType: String, completion: @escaping (Result<[ForumArticle]>) -> Void) {
        
        database.whereField("forumType", isEqualTo: forumType)
            .getDocuments { snapshot, error in
                
                var forumArticles: [ForumArticle] = []
                
                guard let snapshot = snapshot else {
                    
                    print("Error fetching document: \(error!)")
                    
                    completion(Result.failure(error!))
                    
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
                
                let sortForumArticles = forumArticles.sorted { (lhs, rhs) in
                    
                    return lhs.createTime > rhs.createTime
                    
                }
                
                completion(Result.success(sortForumArticles))
                
            }
        
    }
    
    // 取得 屬於論壇的所有文章 至 ArticleViewController
    func fetchSearchData(completion: @escaping (Result<[ForumArticle]>) -> Void) {
        
        database.order(by: "createTime", descending: true)
            .getDocuments { snapshot, error in
                
                var forumArticles: [ForumArticle] = []
                
                guard let snapshot = snapshot else {
                    
                    print("Error fetching document: \(error!)")
                    
                    completion(Result.failure(error!))
                    
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
    
    func fetchForumArticleData(articleID: String, completion: @escaping (Result<ForumArticle>) -> Void) {
        
        database.document(articleID).getDocument { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            do {
                
                if let forumArticle = try snapshot.data(as: ForumArticle.self, decoder: Firestore.Decoder()) {
                    
                    completion(Result.success(forumArticle))
                    
                }
                
            } catch {
                
                print(error)
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
    
    // 修改 論壇區的文章 至 Firebase Firestore
    func updateData(forumArticle: ForumArticle) {
        
        do {

            try database.document(forumArticle.id).setData(from: forumArticle, merge: true)

        } catch {

            print(error)
            
            HUD.flash(.labeledError(title: "修改失敗！", subtitle: "請稍後再試"), delay: 0.5)

        }

    }
    
    // 刪除 論壇區的文章 至 Firebase Firestore
    func deleteData(forumArticle: ForumArticle) {
        
        database.document(forumArticle.id).delete { error in
            
            if let error = error {
                
                print(error)
                
                HUD.flash(.labeledError(title: "刪除失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            } else {
                
                print("Success")
                
            }
            
        }
        
    }
    
}

extension ForumArticleManager {
    
    //  監聽 論壇區的文章留言 從 Firebase Firestore
    func listenMessageData(articleID: String, completion: @escaping (Result<[ArticleMessage]>) -> Void) {
        
        database.document(articleID).collection("message").addSnapshotListener { snapshot, error in
            
            var articleMessages: [ArticleMessage] = []
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let articleMessage = try document.data(as: ArticleMessage.self, decoder: Firestore.Decoder()) {
                        
                        articleMessages.append(articleMessage)
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))
                    
                }
                
            }
                
                completion(Result.success(articleMessages))
            
        }
    }
    
    //  新增 論壇區的文章留言 到 Firebase Firestore
    func addMessageData(articleMessage: ArticleMessage) {
        
        do {
            
            try database
                .document(articleMessage.articleID)
                .collection("message")
                .document("\(Int(articleMessage.createTime))")
                .setData(from: articleMessage)
            
        } catch {
            
            print(error)
            
            HUD.flash(.labeledError(title: "新增失敗！", subtitle: "請稍後再試"), delay: 0.5)
            
        }
        
    }
    
}
