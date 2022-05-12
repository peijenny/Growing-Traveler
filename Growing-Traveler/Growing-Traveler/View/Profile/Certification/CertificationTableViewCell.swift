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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
