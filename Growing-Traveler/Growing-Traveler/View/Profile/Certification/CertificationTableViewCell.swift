//
//  CertificationTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/29.
//

import UIKit

class CertificationTableViewCell: UITableViewCell {

    @IBOutlet weak var certificationTitleLabel: UILabel!
    
    @IBOutlet weak var certificationImageView: UIImageView!
    
    @IBOutlet weak var certificationContentLabel: UILabel!
    
    @IBOutlet weak var certificationBackgroundView: UIView!
    
    @IBOutlet weak var middleBackgroundVIew: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        certificationBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        certificationBackgroundView.cornerRadius = 10
        
        middleBackgroundVIew.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showCertificationData(certification: Certification) {
        
        certificationTitleLabel.text = certification.title
        
        if certification.imageLink != "" {
            
            certificationImageView.loadImage(certification.imageLink)
            
        } else {
            
            certificationImageView.image = UIImage.asset(.userIcon)
            
        }
        
        certificationContentLabel.text = certification.content
        
    }
    
}
