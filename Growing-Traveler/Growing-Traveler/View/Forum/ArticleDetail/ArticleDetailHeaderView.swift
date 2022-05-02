//
//  ArticleDetailHeaderView.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/15.
//

import UIKit

class ArticleDetailHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var forumTypeLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
//    @IBOutlet weak var contentTextView: UITextView!
    
//    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showArticleDetail(forumArticle: ForumArticle, userName: String) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let createTime = Date(timeIntervalSince1970: forumArticle.createTime)
        
        titleLabel.text = forumArticle.title
        
        categoryLabel.text = forumArticle.category.title
        
        createTimeLabel.text = formatter.string(from: createTime)
        
        forumTypeLabel.text = forumArticle.forumType
        
//        userIDLabel.text = forumArticle.userID
        
        userIDLabel.text = userName
        
    }
    
}
