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
    
    var blockadeList: [String]
    
    var applyList: [String]
    
    var deliveryList: [String]
    
}
