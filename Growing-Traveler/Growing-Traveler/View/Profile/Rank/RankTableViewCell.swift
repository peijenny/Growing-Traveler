//
//  OtherRankTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/28.
//

import UIKit

class RankTableViewCell: UITableViewCell {

    @IBOutlet weak var rankNumberLabel: UILabel!
    
    @IBOutlet weak var rankNumberBackgroundView: UIImageView!
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var experienceValueLabel: UILabel!
    
    @IBOutlet weak var friendStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        userPhotoImageView.contentMode = .scaleAspectFill

        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
        
    }
    
    func showRankData(rankNumber: Int, userInfo: UserInfo, blockadeList: [String]) {
        
        if rankNumber == 1 {
            
            rankNumberBackgroundView.tintColor = UIColor.systemYellow
            
        } else if rankNumber == 2 {
            
            rankNumberBackgroundView.tintColor = UIColor.lightGray
            
        } else if rankNumber == 3 {
            
            rankNumberBackgroundView.tintColor = UIColor.systemBrown
            
        } else {
            
            rankNumberBackgroundView.tintColor = UIColor.systemTeal
            
        }
        
        rankNumberLabel.text = "\(rankNumber)"
        
        if userInfo.userPhoto != "" {
            
            userPhotoImageView.loadImage(userInfo.userPhoto)
            
        }

        experienceValueLabel.text = "\(userInfo.achievement.experienceValue)"
        
        userNameLabel.text = userInfo.userName
        
        if blockadeList.filter({ $0 == userInfo.userID }).count == 0 {

            friendStatusLabel.text = nil

        } else {

            friendStatusLabel.text = "[帳號已封鎖]"

        }
        
    }
    
}
