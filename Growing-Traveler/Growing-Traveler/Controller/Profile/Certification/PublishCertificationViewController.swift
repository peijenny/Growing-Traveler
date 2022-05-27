//
//  PublishCertificationViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/29.
//

import UIKit

class PublishCertificationViewController: BaseViewController {

    // MARK: - IBOutlet / Components
    @IBOutlet weak var certificationTitleTextField: UITextField!
    
    @IBOutlet weak var certificationImageTextField: UITextField!
    
    @IBOutlet weak var certificationContentTextView: UITextView!
    
    @IBOutlet weak var uploadImageButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Property
    var userManager = UserManager()
    
    var userInfo: UserInfo?
    
    var modifyCertificationIndex: Int?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if modifyCertificationIndex != nil {

            modifyCertification(index: modifyCertificationIndex ?? 0)
            
        }
        
        certificationContentTextView.layer.borderColor = UIColor.systemGray5.cgColor
        
        certificationContentTextView.layer.borderWidth = 1
        
        certificationContentTextView.layer.cornerRadius = 5
        
        if certificationContentTextView.text == "請描述內容......." {
            
            certificationContentTextView.textColor = UIColor.systemGray3
            
        } else {
            
            certificationContentTextView.textColor = UIColor.black
            
        }

        certificationContentTextView.delegate = self
        
        uploadImageButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        uploadImageButton.cornerRadius = 5
        
        confirmButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        confirmButton.cornerRadius = 5
        
    }
    
    // MARK: - Method
    func modifyCertification(index: Int) {
        
        guard let certification = userInfo?.certification[index] else { return }
        
        certificationTitleTextField.text = certification.title
        
        certificationImageTextField.text = certification.imageLink
        
        certificationContentTextView.text = certification.content

    }

    // MARK: - Target / IBAction
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func uploadImageButton(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        guard let certificationTitle = certificationTitleTextField.text,
              !certificationTitle.isEmpty else {
            
            HandleInputResult.titleEmpty.messageHUD
            
            return
            
        }
        
        guard let certificationImage = certificationImageTextField.text,
              !certificationImage.isEmpty else {
            
            HandleInputResult.uploadImage.messageHUD
            
            return
            
        }
        
        guard let certificationContent = certificationContentTextView.text,
              !certificationContent.isEmpty else {
            
            HandleInputResult.contentEmpty.messageHUD
            
            return
            
        }
        
        if var userInfo = self.userInfo {
            
            if modifyCertificationIndex == nil {
                
                let createTime = TimeInterval(Int(Date().timeIntervalSince1970))
                
                userInfo.certification.append(Certification(
                    createTime: createTime, title: certificationTitle,
                    imageLink: certificationImage, content: certificationContent))
                
                HandleResult.addDataSuccess.messageHUD
                
            } else {
                
                let index = modifyCertificationIndex ?? 0
                
                userInfo.certification[index].title = certificationTitle
                
                userInfo.certification[index].imageLink = certificationImage
                
                userInfo.certification[index].content = certificationContent
                
                HandleResult.updateDataSuccess.messageHUD
                
            }

            userManager.updateUserInfo(user: userInfo)
            
            self.navigationController?.isNavigationBarHidden = false
            
            self.view.removeFromSuperview()
            
        }
        
    }
    
}

// MARK: - ImagePickerController delegate
extension PublishCertificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let self = self else { return }

                switch result {

                case.success(let imageLink):

                    self.certificationImageTextField.text = "\(imageLink)"

                case .failure:
                    
                    HandleResult.readDataFailed.messageHUD
                    
                }

            })

        }

        dismiss(animated: true)

    }
    
}

// MARK: - TextView delegate
extension PublishCertificationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.systemGray3 {
            
            textView.text = nil
            
            textView.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            
            textView.text = "請描述內容......"
            
            textView.textColor = UIColor.systemGray3
            
        }
        
    }
    
}
