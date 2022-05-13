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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showStudyGoalBottom(studyGoal: StudyGoal) {
        
        categoryLabel.text = studyGoal.category.title
        
    }
    
}
