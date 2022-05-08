//
//  StudyGoalHeaderView.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/11.
//

import UIKit

class StudyGoalHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var studyGoalTitleLabel: UILabel!
    
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var hideRecordLabel: UILabel!
    
    @IBOutlet weak var backgroundBottomView: UIView!
    
    @IBOutlet weak var finishItemCountLabel: UILabel!
    
    func showStudyGoalHeader(studyGoal: StudyGoal, isCalendar: Bool) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let endDate = Date(timeIntervalSince1970: studyGoal.studyPeriod.endDate)
        
        endDateLabel.text = "\(formatter.string(from: endDate)) 止"
        
        studyGoalTitleLabel.text = studyGoal.title

        hideRecordLabel.text = "\(studyGoal.id)"
        
        if isCalendar {
            
            backgroundBottomView.isHidden = true
            
        }
        
        let finishItems = studyGoal.studyItems.filter({ $0.isCompleted == true }).count
        
        let totalItems = studyGoal.studyItems.count
        
        finishItemCountLabel.text = "\(finishItems) / \(totalItems)"
        
    }
    
}
