//
//  ArticleTypeTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit

class PublishArticleTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func checkInput() -> Bool {
        
        if categoryTextField.text == "" {

            print(InputError.studyGoalTitleEmpty.title)
            
            return false

        } else if categoryTextField.text == "" {

            print(InputError.categoryEmpty.title)
            
            return false
            
        } else {
            
            print("Save!")
            
            return true
        }
        
    }
    
}
