//
//  NoteTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/29.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTitleLabel: UILabel!
    
    @IBOutlet weak var noteModifyDateLabel: UILabel!
    
    @IBOutlet weak var noteBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showNoteData(note: Note) {

        noteTitleLabel.text = note.noteTitle
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let createTime = Date(timeIntervalSince1970: note.createTime)
        
        noteModifyDateLabel.text = formatter.string(from: createTime)

    }
    
}
