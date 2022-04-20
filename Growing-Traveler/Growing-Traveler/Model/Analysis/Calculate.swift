//
//  Calculate.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/20.
//

import Foundation

struct Calculate: Codable {
    
    var startDate: Date // 開始天數
    
    var endDate: Date // 結束天數
    
    var periodDays: Int // 執行天數
    
    var totalMinutes: Int // 分鐘
    
    var averageMinutes: Int // 分鐘
    
    var includedDays: Int // 包含天數
    
    var included: [Included] // 存有值的天數與分鐘
    
}

struct Included: Codable {
    
    var day: Date
    
    var time: Int
    
}
