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
    
    func showStudyGoalHeader(studyGoal: StudyGoal) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let endDate = Date(timeIntervalSince1970: studyGoal.studyPeriod.endDate)
        
        endDateLabel.text = formatter.string(from: endDate)
        
        studyGoalTitleLabel.text = studyGoal.title

        hideRecordLabel.text = "\(studyGoal.id)"
        
    }
    
}
