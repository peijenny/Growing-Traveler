//
//  Friend.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import Foundation

struct Friend: Codable {
    
    var userID: String
    
    var friendList: [String]
    
    var blockedList: [String]
    
    var applyList: [String]
    
}
