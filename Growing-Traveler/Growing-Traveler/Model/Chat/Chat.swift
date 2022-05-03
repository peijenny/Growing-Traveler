//
//  Chat.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/18.
//

import Foundation

struct Chat: Codable {
    
    var friendID: String
    
    var friendName: String
    
    var messageContent: [MessageContent]
    
}

struct MessageContent: Codable {
    
    var createTime: TimeInterval
    
    var sendMessage: String
    
    var sendType: String
    
    var sendUserID: String
    
}
