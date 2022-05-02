//
//  studyGoalTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/11.
//

import UIKit

class StudyGoalTableViewCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var studyItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func checkIsCompleted(isCompleted: Bool) {
        
        let attributedString = NSMutableAttributedString(string: studyItemLabel.text ?? "")
        
        if isCompleted {
            
            checkButton.tintColor = UIColor.hexStringToUIColor(hex: "0384BD")
            
            studyItemLabel.textColor = UIColor.lightGray
                   
            // 刪除線
            attributedString.addAttribute(
                .strikethroughStyle,
                value: 1,
                range: NSRange(location: 0, length: attributedString.length)
            )
            
            attributedString.addAttribute(
                .strikethroughColor,
                value: UIColor.hexStringToUIColor(hex: "0384BD"),
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
