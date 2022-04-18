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
        
        if isCompleted {
            
            checkButton.backgroundColor = UIColor.black
            
            checkButton.tintColor = UIColor.white
            
        } else {
            
            checkButton.backgroundColor = UIColor.systemGray5
            
            checkButton.tintColor = UIColor.clear
            
        }
        
    }
    
    func showStudyItem(studyItem: StudyItem) {
        
        studyItemLabel.text = studyItem.itemTitle
        
    }
    
}
