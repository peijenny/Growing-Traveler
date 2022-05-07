//
//  UIImage+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/24.
//

import UIKit

enum ImageAsset: String {

    // Profile tab - Tab Bar Icon
    case archery
    case idCard
    case speaker
    case speechBubble
    case book
    
    case calendar
    case award
    case share
    case add
    case block
    case user
    
    case create
    case edit
    
    case telephoneCall
    case videoCamera
    
    case specialDeals
    case vision
    case idea
    case blogging
    case meditation
    
    case undrawUpload

}

// swiftlint:enable identifier_name

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
