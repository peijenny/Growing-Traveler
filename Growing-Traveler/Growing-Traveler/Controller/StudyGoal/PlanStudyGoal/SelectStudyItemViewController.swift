//
//  SelectStudyItemViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/10.
//

import UIKit

class SelectStudyItemViewController: BaseViewController {

    @IBOutlet weak var itemTextField: UITextField!
    
    @IBOutlet weak var studyTimeStackView: UIStackView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var hintLabel: UILabel!
    
    var studyTime = [30, 60, 90, 120, 150]
    
    var timeButtons: [UIButton] = []
    
    var selectStudyTime: Int?
    
    var getStudyItem: ((_ studyItem: StudyItem, _ whetherToUpdate: Bool) -> Void)?
    
    var modifyStudyItem: StudyItem?
    
    var itemNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTimeButton()
        
        if modifyStudyItem != nil {
            
            modifyStudyItemData()
            
        }
        
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
                
                timeButtons[index].backgroundColor = UIColor.black
                
            }
                
        }
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.view.removeFromSuperview()
        
    }
    
    func createTimeButton() {
        // 數量會依據熱門 Tag 的數量決定
        
        for index in 0..<studyTime.count {
            
            let originX = studyTimeStackView.frame.height * CGFloat(index)

            let myButton = UIButton(
                frame: CGRect(
                    x: originX + 5 * CGFloat(index),
                    y: 0,
                    width: studyTimeStackView.frame.height,
                    height: studyTimeStackView.frame.height)
            )
            
            myButton.setTitle("\(studyTime[index])", for: .normal)
            
            myButton.setTitleColor(UIColor.hexStringToUIColor(hex: "69B6CA"), for: .normal)
            
            myButton.isEnabled = true
            
            myButton.backgroundColor = UIColor.hexStringToUIColor(hex: "E5EDF8")
            
            myButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            
            studyTimeStackView.addSubview(myButton)
            
            timeButtons.append(myButton)
            
        }
        
    }

    @objc func clickButton(sender: UIButton) {
        
        _ = timeButtons.map({ $0.backgroundColor = UIColor.hexStringToUIColor(hex: "E5EDF8") })
        
        sender.backgroundColor = UIColor.hexStringToUIColor(hex: "0384BD")
        
        guard let selectSender = sender.titleLabel?.text else { return }
        
        selectStudyTime = Int(selectSender)
        
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        
        if itemTextField?.text == "" {

            HUD.flash(.label(InputError.titleEmpty.title), delay: 0.5)
            
        } else if selectStudyTime == nil {
            
            HUD.flash(.label(InputError.studyTimeEmpty.title), delay: 0.5)
            
        } else if contentTextView.text == "請描述內容......." {
            
            HUD.flash(.label(InputError.contentEmpty.title), delay: 0.5)
            
        } else {
            
            guard let itemTitle = itemTextField?.text,
                  let selectTime = selectStudyTime,
                  let content = contentTextView?.text else {
                return
            }
            
            var studyItem = StudyItem(itemTitle: itemTitle, studyTime: selectTime, content: content, isCompleted: false)
            
            if modifyStudyItem != nil {
                
                studyItem.id = modifyStudyItem?.id

                self.getStudyItem?(studyItem, true)
                
            } else {
                
                studyItem.id = itemNumber
                
                self.getStudyItem?(studyItem, false)
                
            }
            
            self.view.removeFromSuperview()
            
        }
        
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
