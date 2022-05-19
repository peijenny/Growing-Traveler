//
//  ArticleTypeTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit
import PKHUD

class PublishArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    
//    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectCategoryButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        selectCategoryButton.cornerRadius = 5
        
        addImageButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        addImageButton.cornerRadius = 5
        
        typeSegmentedControl.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue  .hexText)
        
        typeSegmentedControl.selectedSegmentTintColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentTextView.layer.borderColor = UIColor.darkGray.cgColor
        
        contentTextView.layer.borderWidth = 1
        
        contentTextView.layer.cornerRadius = 5
        
        if contentTextView.text == "請描述內容......" {
            
            contentTextView.textColor = UIColor.lightGray
            
        } else {
            
            contentTextView.textColor = UIColor.black
            
        }
        
    }
    
    func checkInputType() -> Bool {
        
        if titleTextField.text == "" {

            HUD.flash(.label(InputError.titleEmpty.title), delay: 0.5)
            
        } else if categoryLabel.text == "請選擇分類標籤" {
            
            HUD.flash(.label(InputError.categoryEmpty.title), delay: 0.5)
            
        } else if contentTextView.text == "請描述內容......" {

            HUD.flash(.label(InputError.contentEmpty.title), delay: 0.5)
            
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
            
            if !contentTextView.text.isEmpty {
                
                contentArray = [contentTextView.text]
                
            } else {
                
                HUD.flash(.label(InputError.contentEmpty.title), delay: 0.5)
                
            }
            
        } else {
            
            contentArray = contentTextView
                .attributedText.string.split(separator: "\0").map({ String($0) })
            
        }
        
        return contentArray
        
    }
    
    func modifyForumArticle(modifyForumArticle: ForumArticle) {
        
        categoryLabel.text = modifyForumArticle.category.title
        
        categoryLabel.textColor = UIColor.black

        titleTextField.text = modifyForumArticle.title
        
        var contentText = ""
        
        for index in 0..<modifyForumArticle.content.count {
            
            if modifyForumArticle.content[index].contentType == SendType.image.title {
                
                contentText += "\0\(modifyForumArticle.content[index].contentText)\0"
                
            } else if modifyForumArticle.content[index].contentType == SendType.string.title {
                
                contentText += modifyForumArticle.content[index].contentText
            }
            
        }
        
        contentTextView.text = contentText
        
    }
    
}
