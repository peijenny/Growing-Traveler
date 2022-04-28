//
//  ArticleTypeTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit

class PublishArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var hintLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        contentTextView.layer.borderColor = UIColor.systemGray5.cgColor
        
        contentTextView.layer.borderWidth = 1
        
        contentTextView.layer.cornerRadius = 5
        
        if contentTextView.text == "請描述內容......" {
            
            contentTextView.textColor = UIColor.systemGray3
            
        } else {
            
            contentTextView.textColor = UIColor.black
            
        }
        
    }
    
    func checkInputType() -> Bool {
        
        if titleTextField.text == "" {
            
            hintLabel.text = InputError.titleEmpty.title
            
        } else if categoryTextField.text == "" {
            
            hintLabel.text = InputError.categoryEmpty.title
            
        } else if contentTextView.text == "請描述內容......" {
            
            hintLabel.text = InputError.contentEmpty.title
            
        } else {
            
            return true
            
        }
        
        return false
        
    }
    
    func insertPictureToTextView(imageLink: String) {

        guard let imageURL = URL(string: imageLink) else { return }
        
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
        
        mutableStr.insert(NSAttributedString(string: "\n\0\(imageLink)\0\n\n"), at: selectedRange.location)

        let attribute = [ NSAttributedString.Key.font: UIFont(name: "PingFang TC", size: 15.0)! ]

        contentTextView.attributedText = NSAttributedString(string: mutableStr.string, attributes: attribute)
        
    }
    
    func checkInputContent() -> [String] {
        
        var contentArray: [String] = []
        
        if contentTextView.text.range(of: "https://i.imgur.com") == nil {
            
            if contentTextView.text != "" {
                
                contentArray = [contentTextView.text]
                
            } else {
                
                hintLabel.text = InputError.contentEmpty.title
                
            }
            
        } else {
            
            contentArray = contentTextView
                .attributedText.string.split(separator: "\0").map({ String($0) })
            
        }
        
        return contentArray
        
    }
    
    func modifyForumArticle(modifyForumArticle: ForumArticle) {
        
        categoryTextField.text = modifyForumArticle.category.title

        titleTextField.text = modifyForumArticle.title
        
        var contentText = ""
        
        for index in 0..<modifyForumArticle.content.count {
            
            if modifyForumArticle.content[index].contentType == "image" {
                
                contentText += "\0\(modifyForumArticle.content[index].contentText)\0"
                
            } else {
                
                contentText += modifyForumArticle.content[index].contentText
            }
            
        }
        
        contentTextView.text = contentText
        
    }
    
}
