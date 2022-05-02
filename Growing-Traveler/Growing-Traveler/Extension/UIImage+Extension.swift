//
//  UIImage+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/24.
//

import UIKit

enum ImageAsset: String {

    // Profile tab - Tab Bar Icon
    case loudspeakerOrigin
    case loudspeakerSelect
    
    case targetOrigin
    case targetSelect
    
    case chatBoxOrigin
    case chatBoxSelect
    
    case statisticsOrigin
    case statisticsSelect
    
    case userOrigin
    case userSelect
    
    case timetable
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
