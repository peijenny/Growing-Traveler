//
//  SendTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit

class SendMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var sendMessageLabel: UILabel!
    
    @IBOutlet weak var sendTimeLabel: UILabel!
    
    @IBOutlet weak var sendIamgeView: UIImageView!
    
    @IBOutlet weak var sendMessageView: UIView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sendBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        sendBackgroundView.layer.cornerRadius = 10
        
    }
    
    func showMessage(sendMessage: MessageContent) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        let createTime = Date(timeIntervalSince1970: sendMessage.createTime)
        
        sendTimeLabel.text = formatter.string(from: createTime)

        setMessageContent(message: sendMessage.sendMessage, type: sendMessage.sendType)
        
    }
    
    func setMessageContent(message: String, type: String) {
        
        if type == SendType.string.title {
            
            sendIamgeView.image = nil
            
            imageViewHeightConstraint.constant = 0.0
            
            labelHeightConstraint.constant = 35.0
            
            labelTopConstraint.constant = 10.0
            
            labelBottomConstraint.constant = 10.0
            
            viewConstraint.constant = 55.0
            
            sendMessageLabel.text = message
            
        } else if type == SendType.image.title {

            sendMessageLabel.text = nil
            
            imageViewHeightConstraint.constant = 100.0
            
            labelTopConstraint.constant = 0.0
            
            labelHeightConstraint.constant = 0.0
            
            labelBottomConstraint.constant = 0.0
            
            viewConstraint.constant = 0.0
            
            sendIamgeView.loadImage(message)

        }
        
    }
    
}
