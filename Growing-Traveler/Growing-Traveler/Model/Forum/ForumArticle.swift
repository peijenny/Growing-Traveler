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
    
    var content: [ArticleContent]
    
}

struct ArticleContent: Codable {
    
    var text: [String]?
    
    var image: String?
    
}

struct ArticleMessage: Codable {
    
    var userID: String
    
    var createTime: TimeInterval
    
    var message: [ArticleContent]
    
}

struct UploadImageResult: Decodable {
    
    struct Data: Decodable {
        
        let link: URL
        
    }
    
    let data: Data
}
