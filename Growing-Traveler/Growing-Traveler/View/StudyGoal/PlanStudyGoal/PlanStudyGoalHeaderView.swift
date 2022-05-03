//
//  HeaderView.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit
import PKHUD

class PlanStudyGoalHeaderView: UITableViewHeaderFooterView {
  
    @IBOutlet weak var studyGoalTitleTextField: UITextField!
    
    @IBOutlet weak var startDateTextField: UITextField!
    
    @IBOutlet weak var startDateCalenderButton: UIButton!
    
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBOutlet weak var endDateCalenderButton: UIButton!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var categoryTagButton: UIButton!
    
    @IBOutlet weak var addStudyItemButton: UIButton!
    
    @IBOutlet weak var openEditButton: UIButton!
    
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
    
    func checkFullIn(itemCount: Int, startDate: Date, endDate: Date) -> Bool {
        
        if studyGoalTitleTextField.text == "" {
            
            HUD.flash(.label(InputError.titleEmpty.title), delay: 0.5)

        } else if startDateTextField.text == "" {
            
            HUD.flash(.label(InputError.startDateEmpty.title), delay: 0.5)

        } else if endDateTextField.text == "" {
            
            HUD.flash(.label(InputError.endDateEmpty.title), delay: 0.5)

        } else if categoryTextField.text == "" {
            
            HUD.flash(.label(InputError.categoryEmpty.title), delay: 0.5)

        } else if itemCount == 0 {
            
            HUD.flash(.label(InputError.studyItemEmpty.title), delay: 0.5)

        } else if startDate > endDate {
            
            HUD.flash(.label(InputError.startDatereLativelyLate.title), delay: 0.5)
            
        } else {
            
            return true
            
        }
        
        return false
    }

}
