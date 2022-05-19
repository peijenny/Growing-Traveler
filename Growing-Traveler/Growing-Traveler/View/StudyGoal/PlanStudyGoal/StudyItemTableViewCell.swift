//
//  StudyItemTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/10.
//

import UIKit

class StudyItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemTitleLabel: UILabel!
    
    @IBOutlet weak var studyTimeLabel: UILabel!
    
    @IBOutlet weak var studyItemBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        studyItemBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        studyItemBackgroundView.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showStudyItem(itemTitle: String, studyTime: Int) {
        
        itemTitleLabel.text = itemTitle
        
        studyTimeLabel.text = "學習時間 \(studyTime) 分鐘"
        
    }
    
}
