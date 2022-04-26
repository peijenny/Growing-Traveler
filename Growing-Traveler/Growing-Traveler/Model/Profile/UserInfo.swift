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
    
    var achievement: Achievement
    
}

struct Achievement: Codable {
    
    var experienceValue: Int
    
    var completionGoals: [String] // 存取 StudyGoals ID
    
    var loginDates: [String]
    
}
