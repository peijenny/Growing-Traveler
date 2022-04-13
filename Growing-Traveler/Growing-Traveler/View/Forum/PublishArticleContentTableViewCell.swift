//
//  ArticleContentTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit

class PublishArticleContentTableViewCell: UITableViewCell {

    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func insertPictureToTextView(imageString: String) {

        guard let imageURL = URL(string: imageString) else { return }
        
        let data = try? Data(contentsOf: imageURL)
        
        // 建立圖檔
        let attachment = NSTextAttachment()
        
        guard let image = UIImage(data: data ?? Data()) else { return }
        
        attachment.image = image

        // 設定圖檔的大小
        let imageAspectRatio = CGFloat(image.size.height / image.size.width)

        let imageWidth = contentTextView.frame.width - 2 * CGFloat(0)

        let imageHeight = imageWidth * imageAspectRatio

        attachment.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)

        // 取得 textView 所有的內容，轉成可以修改的
        let mutableStr = NSMutableAttributedString(attributedString: contentTextView.attributedText)
        
        // 取得目前游標的位置
        let selectedRange = contentTextView.selectedRange
        
        mutableStr.insert(NSAttributedString(string: "\0\n\(imageString)"), at: selectedRange.location)

        // 插入圖片後的下一行
        mutableStr.insert(NSAttributedString(string: "\0\n"), at: selectedRange.location + 2)

        let attribute = [ NSAttributedString.Key.font: UIFont(name: "Arial", size: 18.0)! ]

        contentTextView.attributedText = NSAttributedString(string: mutableStr.string, attributes: attribute)
        
    }
    
}
