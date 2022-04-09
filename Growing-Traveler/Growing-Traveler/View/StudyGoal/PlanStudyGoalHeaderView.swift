//
//  HeaderView.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit

class PlanStudyGoalHeaderView: UITableViewHeaderFooterView {
  

    @IBOutlet weak var studyGoalTitleTextField: UITextField!
    
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var startDateCalenderButton: UIButton!
    
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var endDateCalenderButton: UIButton!
    
    @IBOutlet weak var categoryTagLabel: UILabel!
    
    @IBOutlet weak var categoryTagButton: UIButton!
    
    @IBOutlet weak var addStudyItemButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
