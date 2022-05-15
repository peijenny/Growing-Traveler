//
//  ShareSendTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/5.
//

import UIKit

class ShareSendTableViewCell: UITableViewCell {

    @IBOutlet weak var shareImageView: UIImageView!
    
    @IBOutlet weak var shareTitleLabel: UILabel!

    @IBOutlet weak var shareTypeLabel: UILabel!
    
    @IBOutlet weak var sendTimeLabel: UILabel!
    
    @IBOutlet weak var sendBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shareTypeLabel.textColor = UIColor.hexStringToUIColor(hex: ColorChart.blue.hexText)
        
        sendBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        sendBackgroundView.cornerRadius = 10
        
        shareImageView.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCreateTime(sendCreateTime: TimeInterval) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        let createTime = Date(timeIntervalSince1970: sendCreateTime)
        
        sendTimeLabel.text = formatter.string(from: createTime)
        
    }
    
    func showShareNote(note: Note) {
        
        let fistImage = note.content.filter({ $0.contentType == SendType.image.title })
        
        if fistImage.count != 0 {
            
            shareImageView.loadImage(fistImage[0].contentText)
            
        }
        
        shareTitleLabel.text = note.noteTitle
        
        shareTypeLabel.text = "[筆記分享]"
        
    }
    
    func showShareArticle(forumArticle: ForumArticle) {
        
        let fistImage = forumArticle.content.filter({ $0.contentType == SendType.image.title })
        
        if fistImage.count != 0 {
            
            shareImageView.loadImage(fistImage[0].contentText)

        }
        
        shareTitleLabel.text = forumArticle.title
        
        shareTypeLabel.text = "[討論區分享]"
        
    }
    
}
