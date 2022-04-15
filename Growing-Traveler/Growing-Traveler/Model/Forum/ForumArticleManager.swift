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
                .whereField("forumType", isEqualTo: forumTypes[index]).limit(to: 2)
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
                    
                    return lhs.createTime < rhs.createTime
                    
                }
                
                completion(Result.success(sortForumArticles))
                
            }
        
    }
    
    // 修改 論壇區的文章 至 Firebase Firestore
    func updateData(forumArticle: ForumArticle) {
        
        do {

            try database.document(forumArticle.id).setData(from: forumArticle, merge: true)

        } catch {

            print(error)

        }

    }
    
    // 刪除 論壇區的文章 至 Firebase Firestore
    func deleteData(forumArticle: ForumArticle) {
        
        database.document(forumArticle.id).delete { error in
            
            if let error = error {
                
                print(error)
                
            } else {
                
                print("Success")
                
            }
            
        }
        
    }
    
}
