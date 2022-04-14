//
//  ForumArticleManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ForumArticleManager {
    
    let database = Firestore.firestore().collection("forum")
    
    // 上傳 新的論壇文章 至 Firebase Firestore
    func addData(forumArticle: ForumArticle) {
        
        do {
            
            try database.document(forumArticle.id).setData(from: forumArticle)
            
        } catch {
            
            print(error)
            
        }
        
    }
    
    // 取得 屬於論壇的所有文章 至 ArticleViewController
    func fetchData(completion: @escaping (Result<[ForumArticle]>) -> Void) {
        
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
    
}
