//
//  SelectStudyItemViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/10.
//

import UIKit
import PKHUD

enum SelectStatus {
    
    case add
    
    case modify
    
    var title: String {
        
        switch self {
            
        case .add: return "add"
            
        case .modify: return "modify"
            
        }
        
    }
    
}

class SelectStudyItemViewController: BaseViewController {

    @IBOutlet weak var itemTextField: UITextField!
    
    @IBOutlet weak var studyTimeStackView: UIStackView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var copyItemButton: UIButton!
    
    var getStudyItem: ((_ studyItem: StudyItem, _ whetherToUpdate: Bool) -> Void)?
    
    var modifyStudyItem: StudyItem?

    var studyTime = [30, 60, 90, 120, 150]
    
    var timeButtons: [UIButton] = []
    
    var selectStudyTime: Int?
    
    var itemNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTimeButton()
        
        setTextViewAndTextField()
        
        if modifyStudyItem != nil {
            
            modifyStudyItemData()
            
            copyItemButton.isHidden = false
            
        }

    }
    
    func setTextViewAndTextField() {
        
        contentTextView.layer.borderColor = UIColor.systemGray5.cgColor
        
        contentTextView.layer.borderWidth = 1
        
        contentTextView.layer.cornerRadius = 5
        
        if contentTextView.text == "請描述內容......." {
            
            contentTextView.textColor = UIColor.systemGray3
            
        } else {
            
            contentTextView.textColor = UIColor.black
            
        }
        
        contentTextView.delegate = self
        
        itemTextField.delegate = self
        
        itemTextField.delegate = self
        
    }
    
    func modifyStudyItemData() {
        
        itemTextField.text = modifyStudyItem?.itemTitle
        
        contentTextView.text = modifyStudyItem?.content
        
        selectStudyTime = modifyStudyItem?.studyTime
        
        for index in 0..<studyTime.count {
            
            guard let studyTime = modifyStudyItem?.studyTime else { return }
            
            if "\(studyTime)" == timeButtons[index].titleLabel?.text {
                
                timeButtons[index].backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
                
            }
                
        }
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func copyButton(_ sender: UIButton) {
        
        handleStudyItem(status: SelectStatus.add.title)
        
    }
    
    func createTimeButton() {
        
        for index in 0..<studyTime.count {
            
            let originX = (studyTimeStackView.frame.height * CGFloat(index)) + 5 * CGFloat(index)

            let timeButton = UIButton(frame: CGRect(
                x: originX, y: 0, width: studyTimeStackView.frame.height, height: studyTimeStackView.frame.height))
            
            timeButton.cornerRadius = 5
            
            timeButton.setTitle("\(studyTime[index])", for: .normal)
            
            timeButton.setTitleColor(UIColor.white, for: .normal)
            
            timeButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
            
            timeButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            
            timeButton.isEnabled = true
            
            timeButtons.append(timeButton)
            
            studyTimeStackView.addSubview(timeButton)

        }
        
    }

    @objc func clickButton(sender: UIButton) {
        
        _ = timeButtons.map({ $0.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText) })
        
        sender.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        guard let selectSender = sender.titleLabel?.text else { return }
        
        selectStudyTime = Int(selectSender)
        
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        
        if modifyStudyItem != nil {
            
            handleStudyItem(status: SelectStatus.modify.title)
            
        } else {
            
            handleStudyItem(status: SelectStatus.add.title)
            
        }
        
    }
    
    func handleStudyItem(status: String) {
        
        guard let itemTitle = itemTextField?.text, itemTextField?.text != "" else {
            
            HUD.flash(.label(InputError.titleEmpty.title), delay: 0.5)
            
            return
            
        }
        
        guard let selectTime = selectStudyTime, selectStudyTime != nil else {
            
            HUD.flash(.label(InputError.studyTimeEmpty.title), delay: 0.5)
            
            return
            
        }
        
        guard let content = contentTextView?.text, contentTextView.text != "請描述內容......." else {
            
            HUD.flash(.label(InputError.contentEmpty.title), delay: 0.5)
            
            return
            
        }
        
        var studyItem = StudyItem(itemTitle: itemTitle, studyTime: selectTime, content: content, isCompleted: false)
        
        if status == SelectStatus.modify.title {
            
            studyItem.id = modifyStudyItem?.id

            self.getStudyItem?(studyItem, true)
            
        } else {
            
            studyItem.id = itemNumber
            
            self.getStudyItem?(studyItem, false)
            
        }
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.view.removeFromSuperview()
        
    }
    
}

extension SelectStudyItemViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.systemGray3 {
            
            textView.text = nil
            
            textView.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            
            textView.text = "請描述內容......."
            
            textView.textColor = UIColor.systemGray3
            
        }
        
    }
    
}
