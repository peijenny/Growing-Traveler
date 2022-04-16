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
    
//    func setContentText(contents: [ArticleContent]) {
//
//        let voiceAttr = NSMutableAttributedString()
//
//        let imageAttachment = NSTextAttachment()
//
//        do {
//
//            if let url = URL(string: "https://i.imgur.com/ZTia70g.png") {
//
//                let data = try Data(contentsOf: url)
//
//                let image = UIImage(data: data)!
//
//                let imageAspectRatio = image.size.height / image.size.width
//
//                let peddingX: CGFloat =  0
//
//                let imageWidth = contentTextView.frame.width - 2 * peddingX
//
//                let imageHeight = imageWidth * imageAspectRatio
//
//                imageAttachment.image = image
//
//                imageAttachment.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
//
//            }
//
//        } catch {
//
//            print(error)
//
//        }
//
//        let imgAttr = NSAttributedString(attachment: imageAttachment)
//
//        voiceAttr.append(imgAttr)
//
//        let textArt = NSAttributedString(string: "新品推荐\n")
//
//        voiceAttr.append(imgAttr)
//
//        let textArt2 = NSAttributedString(string: "新品推荐2\n")
//
//        voiceAttr.append(textArt)
//
//        voiceAttr.append(textArt2)
//
//        contentTextView.attributedText = voiceAttr
//
//    }
    
}
