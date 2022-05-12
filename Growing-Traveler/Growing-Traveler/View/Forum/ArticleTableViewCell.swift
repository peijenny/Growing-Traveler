//
//  ArticleTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/14.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var forumTypeLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loadMoreButton: UIButton!
    
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showForumArticle(forumArticle: ForumArticle, userName: String) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let createTime = Date(timeIntervalSince1970: forumArticle.createTime)
        
        createTimeLabel.text = formatter.string(from: createTime)
        
        checkImage(forumArticle: forumArticle)

        titleLabel.text = forumArticle.title
        
        forumTypeLabel.text = forumArticle.forumType

        categoryLabel.text = forumArticle.category.title

        userIDLabel.text = userName
        
    }
    
    func checkImage(forumArticle: ForumArticle) {
        
        let article = forumArticle.content.filter({ $0.contentType == SendType.image.title })
        
        if article.count > 0 {
            
            mainImageView.loadImage(article[0].contentText)
            
            imageViewHeightConstraint.constant = 150.0
            
        } else {
            
            imageViewHeightConstraint.constant = 0.0
        }
        
    }
    
    func showLoadMoreButton(amountOver: Bool, isLastOne: Bool) {
        
        if amountOver && isLastOne {
            
            buttonHeightConstraint.constant = 40.0
            
        } else {
            
            buttonHeightConstraint.constant = 0.0
            
        }
        
    }
    
}
