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
        
        noteBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        noteBackgroundView.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showNoteData(note: Note) {

        noteTitleLabel.text = note.noteTitle
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let createTime = Date(timeIntervalSince1970: note.createTime)
        
        noteModifyDateLabel.text = formatter.string(from: createTime)

    }
    
}
