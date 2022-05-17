//
//  FeatureCollectionViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/22.
//

import UIKit

class FeatureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var featureItemLabel: UILabel!
    
    @IBOutlet weak var featureImageView: UIImageView!
    
    @IBOutlet weak var featureBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        featureBackgroundView.layer.cornerRadius = 15
        
        featureBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.blue.hexText)
        
    }

}
