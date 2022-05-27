//
//  BottomTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/10.
//

import UIKit

class BottomTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var categoryBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        categoryBackgroundView.cornerRadius = 10
        
        deleteButton.tintColor = UIColor.systemRed
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showStudyGoalBottom(studyGoal: StudyGoal) {
        
        categoryLabel.text = studyGoal.category.title
        
    }
    
}
