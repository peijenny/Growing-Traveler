//
//  Double+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/21.
//

import UIKit

extension Double {
    
    // 無條件進位
    func ceiling(toDecimal decimal: Int) -> Double {
        
        let numberOfDigits = abs(pow(10.0, Double(decimal)))
        
        if self.sign == .minus {
            
            return Double(Int(self * numberOfDigits)) / numberOfDigits
            
        } else {
            
            return Double(ceil(self * numberOfDigits)) / numberOfDigits
            
        }
        
    }
    
    // 四捨五入
    func rounding(toDecimal decimal: Int) -> Double {
        
        let numberOfDigits = pow(10.0, Double(decimal))
        
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
        
    }
    
}
