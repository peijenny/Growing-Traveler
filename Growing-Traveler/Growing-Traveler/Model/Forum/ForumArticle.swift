//
//  ForumArticle.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import Foundation

struct ForumArticle: Codable {
    
    var id: String

    var userID: String

    var createTime: TimeInterval

    var title: String
    
    var category: CategoryItem
    
    var content: [ArticleContent]
    
    var forumType: String
    
}

struct ArticleContent: Codable {
    
    var orderID: Int
    
    var contentType: String
    
    var contentText: String
    
}

struct ArticleMessage: Codable {
    
    var userID: String
    
    var articleID: String
    
    var createTime: TimeInterval
    
    var message: ArticleContent

}

struct UploadImageResult: Decodable {
    
    struct Data: Decodable {
        
        let link: URL
        
    }
    
    let data: Data
}
