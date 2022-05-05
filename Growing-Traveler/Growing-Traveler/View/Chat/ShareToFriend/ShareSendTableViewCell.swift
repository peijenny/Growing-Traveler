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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
        shareTitleLabel.text = "[筆記分享] \(note.noteTitle)"
        
    }
    
}
