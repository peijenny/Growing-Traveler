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
    
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var shareTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        shareView.layer.cornerRadius = 15
        
        shareImageView.layer.cornerRadius = 15
        
    }
    
    func showShareNote(note: Note) {
        
        let fistImage = note.content.filter({ $0.contentType == SendType.image.title })
        
        if fistImage.count != 0 {
            
            shareImageView.loadImage(fistImage[0].contentText)
            
            imageViewConstraint.constant = 150.0
            
        } else {
            
            shareImageView.image = nil
            
            imageViewConstraint.constant = 0.0
            
        }
        
        shareTitleLabel.text = note.noteTitle
        
        shareTypeLabel.text = "[筆記分享]"
        
    }
    
    func showShareArticle(forumArticle: ForumArticle) {
        
        let fistImage = forumArticle.content.filter({ $0.contentType == SendType.image.title })
        
        if fistImage.count != 0 {
            
            shareImageView.loadImage(fistImage[0].contentText)
            
            imageViewConstraint.constant = 150.0
            
        } else {
            
            shareImageView.image = nil
            
            imageViewConstraint.constant = 0.0
            
        }
        
        shareTitleLabel.text = forumArticle.title
        
        shareTypeLabel.text = "[討論區分享]"
        
    }
    
}
