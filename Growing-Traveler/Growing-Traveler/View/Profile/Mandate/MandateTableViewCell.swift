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
    
    @IBOutlet weak var mandateCompletionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func showMandateItem(mandateItem: MandateItem) {
        
        mandateTitleLabel.text = mandateItem.title
        
        mandateContentLabel.text = mandateItem.content
        
        mandateProgressView.layer.masksToBounds = true
        
        mandateProgressView.layer.cornerRadius = 8.5
        
        var progress = 1.0
        
        if Int(mandateItem.pogress) < mandateItem.upperLimit {

            progress = (1.0 / Double(mandateItem.upperLimit)) * Double(mandateItem.pogress)
            
            mandateCompletionLabel.text = "\(Int(mandateItem.pogress)) / \(mandateItem.upperLimit)"
            
        } else {
            
            mandateCompletionLabel.text = "\(mandateItem.upperLimit) / \(mandateItem.upperLimit)"
            
        }
        
        mandateProgressView.progress = Float(progress)
        
    }
    
}
