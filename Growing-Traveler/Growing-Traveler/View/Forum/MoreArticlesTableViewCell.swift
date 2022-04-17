//
//  MoreArticlesTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/15.
//

import UIKit

class MoreArticlesTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var forumTypeLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showMoreArticles(forumArticle: ForumArticle) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let createTime = Date(timeIntervalSince1970: forumArticle.createTime)
        
        checkImage(forumArticle: forumArticle)

        titleLabel.text = forumArticle.title
        
        forumTypeLabel.text = forumArticle.forumType

        categoryLabel.text = forumArticle.category.title
        
        createTimeLabel.text = formatter.string(from: createTime)

        userIDLabel.text = forumArticle.userID
        
    }
    
    func checkImage(forumArticle: ForumArticle) {
        
        let article = forumArticle.content.filter({ $0.contentType == "image" })
        
        if article.count > 0 {
            
            mainImageView.loadImage(article[0].contentText)
            
            imageViewWidthConstraint.constant = 70.0
            
            imageViewLeadingConstraint.constant = 16.0
            
        } else {
            
            imageViewWidthConstraint.constant = 0.0
            
            imageViewLeadingConstraint.constant = 6.0
        }
        
    }
    
}
