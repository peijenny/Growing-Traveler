//
//  ArticleTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/14.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
