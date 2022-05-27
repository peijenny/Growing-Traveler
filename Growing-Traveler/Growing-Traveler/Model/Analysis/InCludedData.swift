//
//  InCludedData.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/26.
//

import Foundation

struct InCludedData: Codable {
    
    var includedDays: Int
    
    var includedArray: [Included]
    
}

struct CountDate {
    
    var startDate: Date
    
    var endDate: Date
    
    var yesterday: Date
    
    var sevenDaysAgo: Date
    
    var averageTime: Int
    
}
