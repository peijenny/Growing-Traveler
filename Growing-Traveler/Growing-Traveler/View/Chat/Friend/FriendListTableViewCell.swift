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
    
    func showFriendInfo(friendName: String, friendPhotoLink: String) {
        
        friendNameLabel.text = friendName
        
        if friendPhotoLink != "" {
            
            friendIconImageView.loadImage(friendPhotoLink)
            
        }
        
    }
    
}
