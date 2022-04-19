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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showMessage(sendMessage: MessageContent) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        let createTime = Date(timeIntervalSince1970: sendMessage.createTime)
        
        sendTimeLabel.text = formatter.string(from: createTime)

        setMessageContent(message: sendMessage.sendMessage, type: sendMessage.sendType)
        
    }
    
    func setMessageContent(message: String, type: String) {
        
        if type == "string" {
            
            sendMessageLabel.text = message
            
        } else if type == "image" {
            
            sendMessageLabel.text = nil
            
        }
        
    }
    
}
