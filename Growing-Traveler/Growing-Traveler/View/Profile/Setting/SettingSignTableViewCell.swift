//
//  SettingSignTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit

class SettingSignTableViewCell: UITableViewCell {

    @IBOutlet weak var signOutAccountButton: UIButton!
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    @IBOutlet weak var eulaButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        signOutAccountButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        signOutAccountButton.cornerRadius = 5
        
        deleteAccountButton.backgroundColor = UIColor.systemRed
        
        deleteAccountButton.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
