//
//  Array+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/17.
//

import UIKit

extension Array where Element: Equatable {

    func getArrayIndex(_ value :  Element) -> [Int] {
        
        return self.indices.filter {self[$0] == value}
        
    }

}
