//
//  ShareReceiveTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/5.
//

import UIKit

class ShareReceiveTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImageView: UIImageView!
    
    @IBOutlet weak var shareImageView: UIImageView!
    
    @IBOutlet weak var shareTitleLabel: UILabel!
    
    @IBOutlet weak var shareTypeLabel: UILabel!
    
    @IBOutlet weak var receiveTimeLabel: UILabel!
    
    @IBOutlet weak var receiveBackgroundVIew: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shareTypeLabel.textColor = UIColor.hexStringToUIColor(hex: ColorChat.blue.hexText)
        
        receiveBackgroundVIew.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.gray.hexText)
        
        receiveBackgroundVIew.cornerRadius = 10
        
        shareImageView.cornerRadius = 10
        
        friendImageView.cornerRadius = friendImageView.frame.width / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCreateTime(receiveCreateTime: TimeInterval) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        let createTime = Date(timeIntervalSince1970: receiveCreateTime)
        
        receiveTimeLabel.text = formatter.string(from: createTime)
        
    }
    
    func showShareNote(note: Note, userPhoto: String?) {
        
        if userPhoto != nil {
            
            friendImageView.loadImage(userPhoto)
            
        } else {
            
            friendImageView.image = UIImage.asset(.userIcon)
            
        }
        
        let fistImage = note.content.filter({ $0.contentType == SendType.image.title })
        
        if fistImage.count != 0 {
            
            shareImageView.loadImage(fistImage[0].contentText)
            
        }
        
        shareTitleLabel.text = note.noteTitle
        
        shareTypeLabel.text = "[筆記分享]"
        
    }
    
    func showShareArticle(forumArticle: ForumArticle, userPhoto: String?) {
        
        if userPhoto != nil {
            
            friendImageView.loadImage(userPhoto)
            
        } else {
            
            friendImageView.image = UIImage.asset(.userIcon)
            
        }
        
        let fistImage = forumArticle.content.filter({ $0.contentType == SendType.image.title })
        
        if fistImage.count != 0 {
            
            shareImageView.loadImage(fistImage[0].contentText)

        }
        
        shareTitleLabel.text = forumArticle.title
        
        shareTypeLabel.text = "[討論區分享]"
        
    }
    
}
