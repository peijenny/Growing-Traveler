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

class ForumArticleManager {
    
    let database = Firestore.firestore().collection("forum")
    
    // listen forum articles
    func listenData(completion: @escaping (Result<[ForumArticle]>) -> Void) {
        
        var forumArticles: [ForumArticle] = []
        
        let forumTypes: [String] = [
            ForumType.essay.title,
            ForumType.question.title,
            ForumType.chat.title
        ]

        for index in 0..<forumTypes.count {
            
            database.whereField("forumType", isEqualTo: forumTypes[index])
            .order(by: "createTime", descending: true)
            .addSnapshotListener { snapshot, error in
                
                guard let snapshot = snapshot else {
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                for document in snapshot.documents {
                    
                    do {
                        
                        if let forumArticle = try document.data(as: ForumArticle.self, decoder: Firestore.Decoder()) {
                            
                            forumArticles.append(forumArticle)
                            
                        }
                        
                    } catch {
                        
                        completion(Result.failure(error))
                        
                    }
                    
                }
                    
                    completion(Result.success(forumArticles))
                
            }
            
        }

    }
    
    // upload new forum aritlce
    func addData(forumArticle: ForumArticle) {
        
        do {
            
            try database.document(forumArticle.id).setData(from: forumArticle)
            
        } catch {
            
            HandleResult.addDataFailed.messageHUD
            
        }
        
    }
    
    // modify forum article
    func updateArticleData(forumArticle: ForumArticle) {
        
        do {
            
            try database.document(forumArticle.id).setData(from: forumArticle, merge: true)
            
        } catch {
            
            HandleResult.updateDataFailed.messageHUD
            
        }
        
    }
    
    // fetch forum articles
    func fetchData(forumType: String, completion: @escaping (Result<[ForumArticle]>) -> Void) {
        
        database.whereField("forumType", isEqualTo: forumType)
            .getDocuments { snapshot, error in
                
                var forumArticles: [ForumArticle] = []
                
                guard let snapshot = snapshot else {
                    
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
    
    // fetch forum articles
    func fetchSearchData(completion: @escaping (Result<[ForumArticle]>) -> Void) {
        
        database.order(by: "createTime", descending: true)
            .getDocuments { snapshot, error in
                
                var forumArticles: [ForumArticle] = []
                
                guard let snapshot = snapshot else {
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
                
                for document in snapshot.documents {
                    
                    do {
                        
                        if let forumArticle = try document.data(as: ForumArticle.self, decoder: Firestore.Decoder()) {
                            
                            forumArticles.append(forumArticle)
                            
                        }
                        
                    } catch {
                        
                        completion(Result.failure(error))
                        
                    }
                    
                }
                
                completion(Result.success(forumArticles))
                
            }
        
    }
    
    // fetch forum article
    func fetchForumArticleData(articleID: String, completion: @escaping (Result<ForumArticle>) -> Void) {
        
        database.document(articleID).getDocument { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            do {
                
                if let forumArticle = try snapshot.data(as: ForumArticle.self, decoder: Firestore.Decoder()) {
                    
                    completion(Result.success(forumArticle))
                    
                }
                
            } catch {
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
    
    // modify forum article
    func updateData(forumArticle: ForumArticle) {
        
        do {

            try database.document(forumArticle.id).setData(from: forumArticle, merge: true)

        } catch {
            
            HandleResult.updateDataFailed.messageHUD

        }

    }
    
    // delete forum article
    func deleteData(forumArticle: ForumArticle) {
        
        database.document(forumArticle.id).delete { error in
            
            if error != nil {
                
                HandleResult.deleteDataFailed.messageHUD
                
            } else {
                
                HandleResult.deleteDataSuccessed.messageHUD
                
            }
            
        }
        
    }
    
}

extension ForumArticleManager {
    
    // listen article messages
    func listenMessageData(articleID: String, completion: @escaping (Result<[ArticleMessage]>) -> Void) {
        
        database.document(articleID).collection("message").addSnapshotListener { snapshot, error in
            
            var articleMessages: [ArticleMessage] = []
            
            guard let snapshot = snapshot else {
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let articleMessage = try document.data(as: ArticleMessage.self, decoder: Firestore.Decoder()) {
                        
                        articleMessages.append(articleMessage)
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))
                    
                }
                
            }
                
                completion(Result.success(articleMessages))
            
        }
    }
    
    // new article messages
    func addMessageData(articleMessage: ArticleMessage) {
        
        do {
            
            try database.document(articleMessage.articleID).collection("message")
                .document("\(Int(articleMessage.createTime))").setData(from: articleMessage)
            
        } catch {
            
            HandleResult.addDataFailed.messageHUD
            
        }
        
    }
    
}
