//
//  SettingImageTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit

class SettingImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var modifyUserPhotoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        userPhotoImageView.contentMode = .scaleAspectFill

        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
        
//        modifyUserPhotoButton.layer.cornerRadius = modifyUserPhotoButton.frame.width / 2
        
    }
    
    func setUserPhoto(userPhotoLink: String) {
        
        if userPhotoLink != "" {
            
            userPhotoImageView.loadImage(userPhotoLink)
            
        } else {
            
            userPhotoImageView.image = UIImage.asset(.userIcon)
            
        }
        
    }
    
}
