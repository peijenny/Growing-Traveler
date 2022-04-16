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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setArticleContent(content: ArticleContent) {
        
        if content.contentType == "string" {
            
            messageTextLabel.text = content.contentText
            
            messageImageView.image = nil
            
            imageViewHeightConstraint.constant = 0.0
            
        } else if content.contentType == "image" {
            
            messageTextLabel.text = nil
            
            messageImageView.loadImage(content.contentText)
            
            imageViewHeightConstraint.constant = 223.0
            
            labelHeightConstraint.constant = 0.0
            
        }
        
    }
    
}
