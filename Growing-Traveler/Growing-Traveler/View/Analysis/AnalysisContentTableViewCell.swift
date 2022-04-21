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
    
}
