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
import PKHUD

class DeleteUserManager {
    
    let database = Firestore.firestore()
    
    func deleteStudyGoalsData(studyGoals: [StudyGoal]) {

        for index in 0..<studyGoals.count {
            
            database.collection("studyGoal").document(studyGoals[index].id).delete { error in
                
                if let error = error {
                    
                    print(error)
                    
                    HUD.flash(.labeledError(title: "刪除失敗！", subtitle: "請稍後再試"), delay: 0.5)
                    
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
                    
                    HUD.flash(.labeledError(title: "刪除失敗！", subtitle: "請稍後再試"), delay: 0.5)
                    
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
                        
                        HUD.flash(.labeledError(title: "刪除失敗！", subtitle: "請稍後再試"), delay: 0.5)
                        
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
                
                HUD.flash(.labeledError(title: "刪除失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            } else {
                
                print("Success")
            }
            
        }
        
    }
    
    func deleteUserInfoData(deleteUserID: String) {

        database.collection("user").document(deleteUserID).delete { error in
            
            if let error = error {
                
                print(error)
                
                HUD.flash(.labeledError(title: "刪除失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
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
