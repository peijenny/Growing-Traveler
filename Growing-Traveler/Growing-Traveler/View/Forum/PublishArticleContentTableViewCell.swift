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
    
    func insertPictureToTextView(image: UIImage) {
        
        let imageString = "https://i.imgur.com/4KuCb34.jpeg"
        
        let imageURL = URL(string: imageString)
        
        let data = try? Data(contentsOf: imageURL!)
        
        // 建立附檔
        let attachment = NSTextAttachment()
        
        let image = UIImage(data: data ?? Data())!
        
        attachment.image = image

        // 設定附檔的大小
        let imageAspectRatio = CGFloat(image.size.height / image.size.width)

        let peddingX: CGFloat =  0

        let imageWidth = contentTextView.frame.width - 2 * peddingX

        let imageHeight = imageWidth * imageAspectRatio

//        attachment.image = UIImage(data: image.jpegData(compressionQuality: 0.5)!)

        attachment.bounds = CGRect(x: 0, y: 0,
                                   width: imageWidth,
                                   height: imageHeight)

        // 將附檔轉成 NSAttributedString 類型的屬性
        let attImage = NSAttributedString(attachment: attachment)

        // 取得 textView 所有的內容，轉成可以修改的
        let mutableStr = NSMutableAttributedString(attributedString: contentTextView.attributedText)

        // 取得目前游標的位置
        let selectedRange = contentTextView.selectedRange

        // 插入附檔
        mutableStr.insert(attImage, at: selectedRange.location)

        // 插入圖片後的下一行
        mutableStr.insert(NSAttributedString(string: "\n"), at: selectedRange.location + 1)

        contentTextView.attributedText = mutableStr
        
    }
    
}
