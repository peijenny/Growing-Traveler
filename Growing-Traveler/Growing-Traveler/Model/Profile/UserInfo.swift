//
//  User.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import Foundation

struct UserInfo: Codable {
    
    var userID: String
    
    var userName: String
    
    var userEmail: String
    
    var userPhoto: String
    
    var userPhone: String
    
    var signInType: String
    
    var achievement: Achievement
    
    var certification: [Certification]
    
}

struct Certification: Codable {
    
    var createTime: TimeInterval
    
    var title: String
    
    var imageLink: String
    
    var content: String
    
}

struct Achievement: Codable {
    
    var experienceValue: Int
    
    var completionGoals: [String] // 存取 StudyGoals ID
    
    var loginDates: [String]
    
}

struct SignIn: Codable {
    
    var email: String
    
    var password: String
    
}

struct SignUp: Codable {

    var userName: String
    
    var userPhotoLink: String
    
    var email: String
    
    var password: String
    
}

struct Note: Codable {
    
    var userID: String
    
    var noteID: String
    
    var createTime: TimeInterval
    
    var noteTitle: String
    
    var content: [ArticleContent]
    
}
