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
    
    var hexText: String {
        
        switch self {
            
        case .lightGary: return "EBEBE3"
            
        case .gray: return "C7D6DB"
            
        case .lightBlue: return "B2D1E4"
            
        case .blue: return "8ABBE0"
            
        case .darkBlue: return "49A1D8"
            
        }
        
    }
    
}

//enum ColorChart {
//
//    case grayGreen
//
//    case lightGreen
//
//    case tealGreen
//
//    case darkGreen
//
//    case blueGreen
//
//    var hexText: String {
//
//        switch self {
//
//        case .grayGreen: return "ECF4F3"
//
//        case .lightGreen: return "C8F4DE"
//
//        case .tealGreen: return "A4E5D9"
//
//        case .darkGreen: return "66C6BA"
//
//        case .blueGreen: return "649DAD"
//
//        }
//
//    }
//
//}

//enum ColorChart {
//
//    // 淺橘
//    case lightBeige
//
//    // 淺黃
//    case lightYellow
//
//    // 橘色
//    case beige
//
//    // 黃色
//    case yellow
//
//    // 淺綠
//    case lightGreen
//
//    // 淺藍
//    case lightBlue
//
//    // 草綠
//    case teal
//
//    // 深綠
//    case green
//
//    var hexText: String {
//
//        switch self {
//
//        case .lightBeige: return "F9EBC8"
//
//        case .lightYellow: return "FEFBE7"
//
//        case .beige: return "E5CB9F"
//
//        case .yellow: return "EEE4AB"
//
//        case .lightGreen: return "DAE5D0"
//
//        case .lightBlue: return "A0BCC2"
//
//        case .teal: return "99C4C8"
//
//        case .green: return "68A7AD"
//
//        }
//
//    }
//
//}

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
