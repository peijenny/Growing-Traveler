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

        // Configure the view for the selected state
    }
    
    func setUserPhoto(userPhotoLink: String) {
        
        userPhotoImageView.loadImage(userPhotoLink)
        
    }
    
}
