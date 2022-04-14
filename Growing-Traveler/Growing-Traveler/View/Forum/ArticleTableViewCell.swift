//
//  ArticleTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/14.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
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
    
    func checkImage(forumArticle: ForumArticle) {
        
        let article = forumArticle.content.filter({ $0.contentType == "image" })
        
        if article.count > 0 {
            
            mainImageView.loadImage(article[0].contentText)
            
            mainImageView.isHidden = false
            
        } else {
            
            mainImageView.backgroundColor = UIColor.clear
            
            mainImageView.isHidden = true
            
        }
        
    }
    
}
