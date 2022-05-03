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
        
        if blockadeList.filter({ $0 == friendInfo.userID }).count != 0 {
            
            friendNameLabel.text = "\(friendInfo.userName) (帳號已封鎖)"
            
        }  else if deleteAccount {
            
            friendNameLabel.text = "\(friendInfo.userName) (帳號已刪除)"
            
        } else {
            
            friendNameLabel.text = friendInfo.userName
            
        }
        
        if friendInfo.userPhoto != "" {
            
            friendIconImageView.loadImage(friendInfo.userPhoto)
            
        }
        
    }
    
}
