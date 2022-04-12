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
            
            myButton.setTitleColor(UIColor.white, for: .normal)
            
            myButton.isEnabled = true
            
            myButton.backgroundColor = UIColor.lightGray
            
            myButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            
            studyTimeStackView.addSubview(myButton)
            
            timeButtons.append(myButton)
            
        }
        
    }

    @objc func clickButton(sender: UIButton) {
        
        _ = timeButtons.map({ $0.backgroundColor = UIColor.lightGray })
        
        sender.backgroundColor = UIColor.black
        
        guard let selectSender = sender.titleLabel?.text else { return }
        
        selectStudyTime = Int(selectSender)
        
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        
        if itemTextField?.text == "" {
            
            hintLabel.text = "項目名稱不可為空！"
            
        } else if selectStudyTime == nil {
            
            hintLabel.text = "請選擇項目的學習時間！"
            
        } else {
            
            guard let itemTitle = itemTextField?.text,
                  let selectTime = selectStudyTime,
                  let content = contentTextView?.text else {
                return
            }
            
            var studyItem = StudyItem(itemTitle: itemTitle, studyTime: selectTime, content: content, isCompleted: false)
            
            if modifyStudyItem != nil {

                self.getStudyItem?(studyItem, true)
                
            } else {
                
                studyItem.id = itemNumber
                
                self.getStudyItem?(studyItem, false)
                
            }
            
            self.view.removeFromSuperview()
            
        }
        
    }
    
}
