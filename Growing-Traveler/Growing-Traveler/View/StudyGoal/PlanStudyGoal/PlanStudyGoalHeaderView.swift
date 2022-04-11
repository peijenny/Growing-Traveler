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

}
