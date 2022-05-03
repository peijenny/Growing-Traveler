//
//  AnalysisContentTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/21.
//

import UIKit

class AnalysisContentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var topTitleLabel: UILabel!
    
    @IBOutlet weak var topContentLabel: UILabel!
    
    @IBOutlet weak var bottomTitleLabel: UILabel!
    
    @IBOutlet weak var bottomContentLabel: UILabel!
    
    let paragraphStyle = NSMutableParagraphStyle()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showPieText(certificateText: String, interesteText: String) {
        
        topTitleLabel.text = "或許可以延伸的項目："
        
        bottomTitleLabel.text = "可以考取的證照："
        
        var certificateText = certificateText
        
        paragraphStyle.lineSpacing = 10
        
        paragraphStyle.alignment = .left
        
        let interesteAttributes = NSAttributedString(
            string: interesteText,
            attributes: [ NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.font: UIFont(name: "PingFang TC", size: 16.0)! ])
        
        topContentLabel.attributedText = interesteAttributes
        
        if certificateText == "" {
            
            certificateText = "目前暫無推薦考取的證照！"
            
        }
        
        let certificateAttributes = NSAttributedString(
            string: certificateText,
            attributes: [ NSAttributedString.Key.paragraphStyle: paragraphStyle,
                           NSAttributedString.Key.font: UIFont(name: "PingFang TC", size: 16.0)!,
                           NSAttributedString.Key.foregroundColor: UIColor.hexStringToUIColor(hex: "6B799E") ])
        
        bottomContentLabel.attributedText = certificateAttributes
        
    }
    
    func showBarText(feedback: Feedback, experienceValue: Int) {
        
        topTitleLabel.text = "近期學習狀況 → \(feedback.title)"
        
        bottomTitleLabel.text = "近期學習的評語："
        
        paragraphStyle.lineSpacing = 10
        
        paragraphStyle.alignment = .left
        
        let experienceAttributes = NSAttributedString(
            string: "獲得的經驗值： \(experienceValue)",
            attributes: [ NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.font: UIFont(name: "PingFang TC", size: 16.0)!,
                          NSAttributedString.Key.foregroundColor: UIColor.hexStringToUIColor(hex: "0384BD") ])
        
        topContentLabel.attributedText = experienceAttributes
        
        let commentAttributes = NSAttributedString(
            string: feedback.comment,
            attributes: [ NSAttributedString.Key.paragraphStyle: paragraphStyle,
                           NSAttributedString.Key.font: UIFont(name: "PingFang TC", size: 16.0)!,
                          NSAttributedString.Key.foregroundColor: UIColor.hexStringToUIColor(hex: "6B799E") ])
        
        bottomContentLabel.attributedText = commentAttributes
        
    }
    
}
