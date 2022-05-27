//
//  ArticleDetailTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/16.
//

import UIKit

class ArticleDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentTextLabel: UILabel!
    
    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setArticleContent(content: ArticleContent, isNote: Bool) {
        
        if content.contentType == SendType.string.title {
            
            contentTextLabel.text = content.contentText
            
            contentImageView.image = nil
            
            imageViewHeightConstraint.constant = 0.0
            
        } else if content.contentType == SendType.image.title {
            
            contentTextLabel.text = nil
            
            contentImageView.loadImage(content.contentText)
            
            imageViewHeightConstraint.constant = 223.0
            
            labelHeightConstraint.constant = 0.0
            
        }
        
        if isNote {
            
            self.contentView.backgroundColor = UIColor.clear
            
        }

    }
    
}
