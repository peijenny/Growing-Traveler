//
//  TableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/18.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendIconImageView: UIImageView!
    
    @IBOutlet weak var friendNameLabel: UILabel!
    
    @IBOutlet weak var friendStatusLabel: UILabel!
    
    @IBOutlet weak var unblockButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        friendIconImageView.contentMode = .scaleAspectFill

        friendIconImageView.layer.cornerRadius = friendIconImageView.frame.width / 2
        
    }
    
    func showFriendInfo(friendInfo: UserInfo, blockadeList: [String], deleteAccount: Bool) {
        
        friendNameLabel.text = friendInfo.userName
        
        friendStatusLabel.text = ""
        
        if blockadeList.filter({ $0 == friendInfo.userID }).count != 0 {
            
            friendNameLabel.text = "\(friendInfo.userName)"
            
            friendStatusLabel.text = "[帳號已封鎖]"
            
        } 
        
        if deleteAccount {
            
            friendNameLabel.text = "\(friendInfo.userName)"
            
            friendStatusLabel.text = "[帳號已刪除]"
            
        }
        
        if friendInfo.userPhoto != "" {
            
            friendIconImageView.loadImage(friendInfo.userPhoto)
            
        }
        
    }
    
    func showBlockadeUserInfo(friendInfo: UserInfo) {
        
        unblockButton.isHidden = false
        
        friendNameLabel.text = friendInfo.userName
        
        friendStatusLabel.text = ""
        
        if friendInfo.userPhoto != "" {
            
            friendIconImageView.loadImage(friendInfo.userPhoto)
            
        }
        
    }
    
}
