//
//  StudyItem.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/10.
//

import Foundation

struct StudyGoal: Codable {
    
    var id: String
    
    var title: String
    
    var category: CategoryItem
    
    var studyPeriod: StudyPeriod
    
    var studyItems: [StudyItem]
    
    var createTime: TimeInterval
    
    var userID: String
}

struct StudyPeriod: Codable {
    
    var startTime: TimeInterval
    
    var endTime: TimeInterval
    
}

struct StudyItem: Codable {
    
    var itemTitle: String
    
    var studyTime: Int
    
    var content: String
    
    var isCompleted: Bool
    
}
