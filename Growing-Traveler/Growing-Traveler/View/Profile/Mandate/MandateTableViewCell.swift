//
//  MandateTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/22.
//

import UIKit

class MandateTableViewCell: UITableViewCell {

    @IBOutlet weak var mandateImageView: UIImageView!
    
    @IBOutlet weak var mandateTitleLabel: UILabel!
    
    @IBOutlet weak var mandateContentLabel: UILabel!
    
    @IBOutlet weak var mandateProgressView: UIProgressView!
    
    @IBOutlet weak var mandateCompletionLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
