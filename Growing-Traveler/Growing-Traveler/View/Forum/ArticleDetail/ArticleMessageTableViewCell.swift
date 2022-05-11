//
//  ArticleMessageTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/16.
//

import UIKit

class ArticleMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var messageTextLabel: UILabel!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var friendStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setArticleContent(content: ArticleContent, isBlock: Bool) {
        
        if isBlock {
            
            messageTextLabel.text = "已封鎖的內容將無法預見！"
            
        } else {
            
            if content.contentType == SendType.string.title {
                
                messageTextLabel.text = content.contentText
                
                messageImageView.image = nil
                
                imageViewHeightConstraint.constant = 0.0
                
            } else if content.contentType == SendType.image.title {
                
                messageTextLabel.text = nil
                
                messageImageView.loadImage(content.contentText)
                
                imageViewHeightConstraint.constant = 223.0
                
                labelHeightConstraint.constant = 0.0
                
            }
            
        }
        
    }
    
    func showMessages(articleMessage: ArticleMessage, articleUserID: String, userName: String, isBlock: Bool) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        let createTime = Date(timeIntervalSince1970: articleMessage.createTime)
        
        userIDLabel.text = userName
        
        friendStatusLabel.text = nil
        
        if articleMessage.userID == articleUserID {
      
            userIDLabel.text = "\(userName) (原Po)"
            
        }
        
        if userName == "[帳號已刪除]" {
            
            userIDLabel.text = "已刪除的使用者"
            
            friendStatusLabel.text = "[帳號已刪除]"
            
        } else if isBlock {
            
            friendStatusLabel.text = "[帳號已封鎖]"
            
            userIDLabel.text = "已封鎖的使用者"
            
        }
                
        createTimeLabel.text = formatter.string(from: createTime)
        
        orderIDLabel.text = "[\(articleMessage.message.orderID + 1) 樓]"
        
        setArticleContent(content: articleMessage.message, isBlock: isBlock)
        
    }
    
}
