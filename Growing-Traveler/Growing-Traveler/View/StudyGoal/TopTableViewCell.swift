//
//  TopTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/10.
//

import UIKit

class TopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var studyGoalTitleLabel: UILabel!
    
    @IBOutlet weak var endDateLabel: UILabel!

    @IBOutlet weak var backgroundBottomView: UIView!
    
    @IBOutlet weak var finishItemCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showStudyGoalHeader(studyGoal: StudyGoal, isCalendar: Bool) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let endDate = Date(timeIntervalSince1970: studyGoal.studyPeriod.endDate)
        
        endDateLabel.text = "\(formatter.string(from: endDate)) 止"
        
        studyGoalTitleLabel.text = studyGoal.title

        if isCalendar {
            
            backgroundBottomView.isHidden = true
            
        }
        
        let finishItems = studyGoal.studyItems.filter({ $0.isCompleted == true }).count
        
        let totalItems = studyGoal.studyItems.count
        
        finishItemCountLabel.text = "\(finishItems) / \(totalItems)"
        
    }
    
}
