//
//  Feedback.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/21.
//

import Foundation

struct Feedback: Codable {
    
    var title: String
    
    var timeLimit: TimeLimit
    
    var comment: String
    
}

struct TimeLimit: Codable {
    
    var lower: Int
    
    var upper: Int
    
}
