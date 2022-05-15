//
//  ArticleMessageHeaderView.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/16.
//

import UIKit

class ArticleMessageHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var shareToFriendButton: UIButton!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shareToFriendButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        shareToFriendButton.cornerRadius = 5
        
        sendMessageButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        sendMessageButton.cornerRadius = 5
        
    }
    
}
