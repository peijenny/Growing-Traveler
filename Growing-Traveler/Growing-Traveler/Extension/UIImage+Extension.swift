//
//  UIImage+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/24.
//

import UIKit

enum ImageAsset: String {

    // Profile tab - Tab Bar Icon
    case archeryOrigin
    case archerySelect
    
    case idCardOrigin
    case idCardSelect
    
    case notepadOrigin
    case notepadSelect
    
    case speakerOrigin
    case speakerSelect
    
    case speechBubbleOrigin
    case speechBubbleSelect
    
    case bookOrigin
    case bookSelect
    
    case calendar
    case award
    
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
