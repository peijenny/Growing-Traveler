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
        // Initialization code
        
        featureBackgroundView.layer.borderWidth = 0.5
        
        featureBackgroundView.layer.borderColor = UIColor.lightGray.cgColor
        
    }

}
