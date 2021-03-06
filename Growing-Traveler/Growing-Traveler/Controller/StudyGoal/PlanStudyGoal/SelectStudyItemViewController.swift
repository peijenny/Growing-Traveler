//
//  SelectStudyItemViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/10.
//

import UIKit

class SelectStudyItemViewController: BaseViewController {

    // MARK: - IBOutlet / Components
    @IBOutlet weak var itemTextField: UITextField!
    
    @IBOutlet weak var studyTimeStackView: UIStackView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var copyItemButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Property
    var getStudyItem: ((_ studyItem: StudyItem, _ whetherToUpdate: Bool) -> Void)?

    var studyTime = [30, 60, 90, 120, 150]
    
    var timeButtons: [UIButton] = []
    
    var modifyStudyItem: StudyItem?
    
    var selectStudyTime: Int?
    
    var itemNumber: Int?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTimeButton()
        
        if modifyStudyItem != nil {
            
            modifyStudyItemData()
            
            copyItemButton.isHidden = false
            
        }
        
        setTextViewAndTextField()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        copyItemButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.blue.hexText)
        
        submitButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        copyItemButton.layer.cornerRadius = 5

        submitButton.layer.cornerRadius = 5
        
    }
    
    // MARK: - Set UI
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
    
    // MARK: - Method
    func modifyStudyItemData() {
        
        itemTextField.text = modifyStudyItem?.itemTitle
        
        contentTextView.text = modifyStudyItem?.content
        
        selectStudyTime = modifyStudyItem?.studyTime
        
        for index in 0..<studyTime.count {
            
            guard let studyTime = modifyStudyItem?.studyTime else { return }
            
            if "\(studyTime)" == timeButtons[index].titleLabel?.text {
                
                timeButtons[index].backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
                
            }
                
        }
    }
    
    func createTimeButton() {
        
        for index in 0..<studyTime.count {

            let timeButton = UIButton()
            
            timeButton.cornerRadius = 5
            
            timeButton.setTitle("\(studyTime[index])", for: .normal)
            
            timeButton.setTitleColor(UIColor.white, for: .normal)
            
            timeButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
            
            timeButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            
            timeButton.isEnabled = true
            
            timeButtons.append(timeButton)
            
            studyTimeStackView.addSubview(timeButton)
            
            timeButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                timeButton.leadingAnchor.constraint(
                    equalTo: studyTimeStackView.leadingAnchor,
                    constant: studyTimeStackView.frame.height * CGFloat(index) * CGFloat(1.1)),
                timeButton.centerYAnchor.constraint(equalTo: studyTimeStackView.centerYAnchor),
                timeButton.widthAnchor.constraint(equalToConstant: studyTimeStackView.frame.height),
                timeButton.heightAnchor.constraint(equalToConstant: studyTimeStackView.frame.height)
            ])

        }
        
    }
    
    func handleStudyItem(status: String) {
        
        guard let itemTitle = itemTextField?.text, !itemTitle.isEmpty else {
            
            HandleInputResult.titleEmpty.messageHUD
            
            return
            
        }
        
        guard let selectTime = selectStudyTime, selectStudyTime != nil else {
            
            HandleInputResult.studyItemEmpty.messageHUD
            
            return
            
        }
        
        guard let content = contentTextView?.text, contentTextView.text != "請描述內容......." else {
            
            HandleInputResult.contentEmpty.messageHUD
            
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
    
    // MARK: - Target / IBAction
    @objc func clickButton(sender: UIButton) {
        
        _ = timeButtons.map({ $0.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText) })
        
        sender.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        guard let selectSender = sender.titleLabel?.text else { return }
        
        selectStudyTime = Int(selectSender)
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func copyButton(_ sender: UIButton) {
        
        handleStudyItem(status: SelectStatus.add.title)
        
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        
        if modifyStudyItem != nil {
            
            handleStudyItem(status: SelectStatus.modify.title)
            
        } else {
            
            handleStudyItem(status: SelectStatus.add.title)
            
        }
        
    }
    
}

// MARK: - TextView delegate
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
