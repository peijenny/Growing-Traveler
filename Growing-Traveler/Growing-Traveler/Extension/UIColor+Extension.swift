//
//  UIColor+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/1.
//

import UIKit

enum ColorChart {
    
    case lightGary
    
    case gray
    
    case lightBlue
    
    case blue
    
    case darkBlue
    
    case lightRed
    
    var hexText: String {
        
        switch self {
            
        case .lightGary: return "EBEBE3"
            
        case .gray: return "C1BFCE"
            
        case .lightBlue: return "B2D1E4"
            
        case .blue: return "8ABBE0"
            
        case .darkBlue: return "49A1D8"
            
        case .lightRed: return "D8A196"
            
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
            alpha: CGFloat(1.0)
        )
        
    }
    
}
