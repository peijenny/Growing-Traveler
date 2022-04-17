//
//  HeaderView.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit

class PlanStudyGoalHeaderView: UITableViewHeaderFooterView {
  
    @IBOutlet weak var studyGoalTitleTextField: UITextField!
    
    @IBOutlet weak var startDateTextField: UITextField!
    
    @IBOutlet weak var startDateCalenderButton: UIButton!
    
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBOutlet weak var endDateCalenderButton: UIButton!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var categoryTagButton: UIButton!
    
    @IBOutlet weak var addStudyItemButton: UIButton!
    
    @IBOutlet weak var hintLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showSelectedDate(dateType: String, startDate: Date, endDate: Date) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        if dateType == SelectDateType.startDate.title {
            
            startDateTextField.text = formatter.string(from: startDate)
            
        } else if dateType == SelectDateType.endDate.title {
            
            endDateTextField.text = formatter.string(from: endDate)
            
        }
        
    }
    
    func modifyStudyGoal(studyGoal: StudyGoal?) {
        
        if studyGoal != nil {
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy.MM.dd"
            
            guard let studyGoal = studyGoal else { return }
            
            studyGoalTitleTextField.text = studyGoal.title
            
            startDateTextField.text = formatter.string(from: Date(
                timeIntervalSince1970: studyGoal.studyPeriod.startDate))

            endDateTextField.text = formatter.string(from: Date(
                timeIntervalSince1970: studyGoal.studyPeriod.endDate))
            
            categoryTextField.text = studyGoal.category.title
            
        }

    }
    
    func checkFullIn(studyItemsCount: Int) -> Bool {
        
        if studyGoalTitleTextField.text == "" {

            hintLabel.text = InputError.titleEmpty.title

        } else if startDateTextField.text == "" {

            hintLabel.text = InputError.startDateEmpty.title

        } else if endDateTextField.text == "" {

            hintLabel.text = InputError.endDateEmpty.title

        } else if categoryTextField.text == "" {

            hintLabel.text = InputError.categoryEmpty.title

        } else if studyItemsCount == 0 {

            hintLabel.text = InputError.studyItemEmpty.title

        } else {
            
            return true
            
        }
        
        return false
    }

}
