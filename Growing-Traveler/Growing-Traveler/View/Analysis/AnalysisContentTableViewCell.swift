//
//  AnalysisContentTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/21.
//

import UIKit

class AnalysisContentTableViewCell: UITableViewCell {

    @IBOutlet weak var interesteLabel: UILabel!
    
    @IBOutlet weak var certificateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showPieText(certificateText: String, interesteText: String) {
        
        var certificateText = certificateText
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 10
        
        paragraphStyle.alignment = .left
        
        let interesteAttributes = NSAttributedString(
            string: interesteText,
            attributes: [ NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.font: UIFont(name: "PingFang TC", size: 15.0)! ])
        
        interesteLabel.attributedText = interesteAttributes
        
        if certificateText == "" {
            
            certificateText = "目前暫無推薦考取的證照！"
            
        }
        
        let certificateAttributes = NSAttributedString(
            string: certificateText,
            attributes: [ NSAttributedString.Key.paragraphStyle: paragraphStyle,
                           NSAttributedString.Key.font: UIFont(name: "PingFang TC", size: 15.0)!,
                           NSAttributedString.Key.foregroundColor: UIColor.orange ])
        
        certificateLabel.attributedText = certificateAttributes
        
    }
    
}
