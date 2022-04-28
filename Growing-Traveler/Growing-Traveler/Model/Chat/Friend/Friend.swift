//
//  Friend.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import Foundation

struct BothSides: Codable {
    
    var owner: Friend
    
    var other: Friend
    
}

struct Friend: Codable {
    
    var userID: String
    
    var userName: String
    
    var friendList: [String]
    
    var blockadeList: [String]
    
    var applyList: [String]
    
    var deliveryList: [String]
    
}
