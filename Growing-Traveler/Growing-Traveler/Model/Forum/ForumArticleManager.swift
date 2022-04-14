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
    
    // 上傳 新建的學習計劃 至 Firebase Firestore
    func addData(forumArticle: ForumArticle) {
        
        do {
            
            try database.document(forumArticle.id).setData(from: forumArticle)
            
        } catch {
            
            print(error)
            
        }
        
    }
    
}
