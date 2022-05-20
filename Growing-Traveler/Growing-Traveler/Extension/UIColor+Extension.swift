//
//  UIColor+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/1.
//

import UIKit

enum ColorChat {
    
    case lightGary
    
    case gray
    
    case lightBlue
    
    case blue
    
    case darkBlue
    
    case salviaBlue
    
    case lightRed
    
    var hexText: String {
        
        switch self {
            
        case .lightGary: return "E6E6E6"
            // E6E6E6
            // EBEBE3
            
        case .gray: return "C1BFCE"
            // C4C4C4
            // C1BFCE
            
        case .lightBlue: return "B2D1E4"
            // C1DDDF
            
        case .blue: return "8ABBE0"
            // 79C5CF
            
        case .darkBlue: return "49A1D8"
            // 0093C1
            
        case .salviaBlue: return "6E799A"
            // 0E305D
            
        case .lightRed: return "D8A196"
            // F08080
            
        }
        
    }
    
}

extension UIColor {

    static func hexStringToUIColor(hex: String) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            
            cString.remove(at: cString.startIndex)
            
        }

        if (cString.count) != 6 {
            
            return UIColor.gray
            
        }

        var rgbValue: UInt64 = 0
        
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
        
    }
    
}
