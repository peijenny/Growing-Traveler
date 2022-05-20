//
//  ProfileView.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/22.
//

import UIKit

class ProfileView: UIView, NibOwnerLoadable {

    @IBOutlet weak var profileBackgroundView: UIView!
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var experienceValueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        customInit()
        
    }
    
    private func customInit() {
        
        loadNibContent()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        userPhotoImageView.contentMode = .scaleAspectFill

        userPhotoImageView.cornerRadius = userPhotoImageView.frame.width / 2
        
        userNameLabel.textColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
    }

}
