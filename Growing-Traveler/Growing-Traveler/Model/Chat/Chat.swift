//
//  Chat.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/18.
//

import Foundation

struct Chat: Codable {
    
    var friendID: String
    
    var messageContent: [MessageContent]
    
}

struct MessageContent: Codable {
    
    var createTime: TimeInterval
    
    var sendMessage: String
    
    var sendType: String
    
    var sendUserID: String
}

struct Friend: Codable {
    
    var userID: String
    
    var friendList: [String]
    
    var blockedList: [String]
    
    var applyList: [String]
    
}

struct User: Codable {
    
    var userID: String
    
    var userName: String
    
}
