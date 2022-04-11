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
}

struct StudyPeriod: Codable {
    
    var startTime: Date
    
    var endTime: Date
    
}

struct StudyItem: Codable {
    
    var itemTitle: String
    
    var studyTime: Int
    
    var content: String
    
    var isCompleted: Bool
    
}
