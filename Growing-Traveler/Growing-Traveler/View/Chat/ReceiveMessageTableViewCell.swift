//
//  ReceiveTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit

class ReceiveMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImageView: UIImageView!
    
    @IBOutlet weak var receiveMessageLabel: UILabel!
    
    @IBOutlet weak var receiveTimeLabel: UILabel!
    
    @IBOutlet weak var receiveImageView: UIImageView!
    
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var receiveBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        receiveBackgroundView.layer.cornerRadius = 10
        
    }
    
    func showMessage(receiveMessage: MessageContent) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        let createTime = Date(timeIntervalSince1970: receiveMessage.createTime)
        
        receiveTimeLabel.text = formatter.string(from: createTime)

        setMessageContent(message: receiveMessage.sendMessage, type: receiveMessage.sendType)
        
    }
    
    func setMessageContent(message: String, type: String) {
        
        if type == "string" {
            
            receiveImageView.image = nil
            
            imageViewHeightConstraint.constant = 0.0
            
            labelHeightConstraint.constant = 35.0
            
            labelTopConstraint.constant = 10.0
            
            labelBottomConstraint.constant = 10.0
            
            viewConstraint.constant = 55.0
            
            receiveMessageLabel.text = message
            
        } else if type == "image" {
            
            receiveMessageLabel.text = nil
            
            imageViewHeightConstraint.constant = 100.0
            
            labelTopConstraint.constant = 0.0
            
            labelHeightConstraint.constant = 0.0
            
            labelBottomConstraint.constant = 0.0
            
            viewConstraint.constant = 0.0
            
            receiveImageView.loadImage(message)

        }
        
    }
    
}
