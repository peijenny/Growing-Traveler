//
//  studyGoalTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/11.
//

import UIKit

protocol CheckStudyItemDelegate: AnyObject {
    
    func checkItemCompleted(studyGoalTableViewCell: StudyGoalTableViewCell, studyItemCompleted: Bool)
    
}

class StudyGoalTableViewCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var studyItemLabel: UILabel!
    
    weak var delegate: CheckStudyItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
        checkButton.cornerRadius = 5
        
        checkButton.addTarget(self, action: #selector(checkItemButton), for: .touchUpInside)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func checkItemButton(sender: UIButton) {
        
        if sender.tintColor?.cgColor == UIColor.clear.cgColor {
            
            sender.tintColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
            
            delegate?.checkItemCompleted(studyGoalTableViewCell: self, studyItemCompleted: true)

        } else {
            
            sender.tintColor = UIColor.clear
            
            delegate?.checkItemCompleted(studyGoalTableViewCell: self, studyItemCompleted: false)
            
        }

    }
    
    func checkIsCompleted(isCompleted: Bool) {
        
        let attributedString = NSMutableAttributedString(string: studyItemLabel.text ?? "")
        
        if isCompleted {
            
            checkButton.tintColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
            
            studyItemLabel.textColor = UIColor.lightGray
                   
            // 刪除線
            attributedString.addAttribute(
                .strikethroughStyle,
                value: 1,
                range: NSRange(location: 0, length: attributedString.length)
            )
            
            attributedString.addAttribute(
                .strikethroughColor,
                value: UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText),
                range: NSRange(location: 0, length: attributedString.length)
            )
            
        } else {
            
            checkButton.tintColor = UIColor.clear
            
            studyItemLabel.textColor = UIColor.black
            
            // 刪除線
            attributedString.addAttribute(
                .strikethroughStyle,
                value: 0,
                range: NSRange(location: 0, length: attributedString.length)
            )

            attributedString.addAttribute(
                .strikethroughColor,
                value: UIColor.clear,
                range: NSRange(location: 0, length: attributedString.length)
            )
            
        }
        
        studyItemLabel.attributedText = attributedString
        
    }
    
    func showStudyItem(studyItem: StudyItem) {
        
        studyItemLabel.text = studyItem.itemTitle
        
    }
    
}
