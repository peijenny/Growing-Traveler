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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showMessage(receiveMessage: MessageContent) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        let createTime = Date(timeIntervalSince1970: receiveMessage.createTime)
        
        receiveTimeLabel.text = "\(createTime)"

        setMessageContent(message: receiveMessage.sendMessage, type: receiveMessage.sendType)
        
    }
    
    func setMessageContent(message: String, type: String) {
        
        if type == "string" {
            
            receiveMessageLabel.text = message
            
        } else if type == "image" {
            
            receiveMessageLabel.text = nil
            
        }
        
    }
    
}
