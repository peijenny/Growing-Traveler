//
//  Category.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import Foundation

struct Category: Codable {
    
    var title: String
    
    var items: [CategoryItem]
    
}

struct CategoryItem: Codable {
    
    var id: Int
    
    var title: String
    
    var intereste: String
    
    var certificate: [String]
    
}
