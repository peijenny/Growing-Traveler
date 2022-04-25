//
//  Mandate.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/23.
//

import Foundation

struct Mandate: Codable {
    
    var mandateID: Int
    
    var mandate: [MandateItem]
    
    var mandateTitle: String
    
}

struct MandateItem: Codable {
    
    var id: Int
    
    var title: String
    
    var content: String
    
    var upperLimit: Int
    
    var pogress: Int
    
}
