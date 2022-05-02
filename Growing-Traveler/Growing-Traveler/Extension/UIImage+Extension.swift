//
//  UIImage+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/24.
//

import UIKit

enum ImageAsset: String {

    // Profile tab - Tab Bar Icon
    case checklistOrigin
    case checklistSelect
    
    case askOrigin
    case askSelect
    
    case commentsOrigin
    case commentsSelect
    
    case chartOrigin
    case chartSelect
    
    case userOrigin
    case userSelect
    
    case calendar
    
    case telephoneCall
    case videoCamera
    
    case specialDeals
    case vision
    case idea
    case blogging
    case meditation

}

// swiftlint:enable identifier_name

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
