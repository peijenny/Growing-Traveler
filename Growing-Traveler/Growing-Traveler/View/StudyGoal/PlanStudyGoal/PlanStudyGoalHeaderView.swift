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
    
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var startDateCalenderButton: UIButton!
    
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var endDateCalenderButton: UIButton!

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var categoryTagButton: UIButton!
    
    @IBOutlet weak var addStudyItemButton: UIButton!
    
    @IBOutlet weak var openEditButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        startDateCalenderButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        startDateCalenderButton.cornerRadius = 5
        
        endDateCalenderButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        endDateCalenderButton.cornerRadius = 5
        
        categoryTagButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        categoryTagButton.cornerRadius = 5
        
        addStudyItemButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        addStudyItemButton.cornerRadius = 5
        
        openEditButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        openEditButton.cornerRadius = 5
        
    }
    
    func showCategoryItem(itemTitle: String) {
        
        categoryLabel.text = itemTitle
        
        if categoryLabel.text ?? "" != "請選擇分類標籤" {
            
            categoryLabel.textColor = UIColor.black
            
        }
        
    }
    
    func showSelectedDate(dateType: String, startDate: Date, endDate: Date) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        if dateType == SelectDateType.startDate.title {
            
            startDateLabel.text = formatter.string(from: startDate)
            
            startDateLabel.textColor = UIColor.black
            
        } else if dateType == SelectDateType.endDate.title {
            
            endDateLabel.text = formatter.string(from: endDate)
            
            endDateLabel.textColor = UIColor.black
            
        }
        
    }
    
    func modifyStudyGoal(studyGoal: StudyGoal?) {
        
        if studyGoal != nil {
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy.MM.dd"
            
            guard let studyGoal = studyGoal else { return }
            
            studyGoalTitleTextField.text = studyGoal.title
            
            startDateLabel.text = formatter.string(from: Date(
                timeIntervalSince1970: studyGoal.studyPeriod.startDate))
            
            startDateLabel.textColor = UIColor.black

            endDateLabel.text = formatter.string(from: Date(
                timeIntervalSince1970: studyGoal.studyPeriod.endDate))
            
            endDateLabel.textColor = UIColor.black
            
            categoryLabel.text = studyGoal.category.title
            
            categoryLabel.textColor = UIColor.black
            
        }

    }
    
    func checkFullIn(itemCount: Int, startDate: Date, endDate: Date) -> Bool {
        
        if studyGoalTitleTextField.text == "" {
            
            HUD.flash(.label(InputError.titleEmpty.title), delay: 0.5)

        } else if startDateLabel.text == "請選擇開始日期" {
            
            HUD.flash(.label(InputError.startDateEmpty.title), delay: 0.5)

        } else if endDateLabel.text == "請選擇結束日期" {
            
            HUD.flash(.label(InputError.endDateEmpty.title), delay: 0.5)

        } else if categoryLabel.text == "請選擇分類標籤" {
            
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
