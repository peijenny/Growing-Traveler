//
//  PublishCertificationViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/29.
//

import UIKit
import PKHUD

class PublishCertificationViewController: BaseViewController {

    @IBOutlet weak var certificationTitleTextField: UITextField!
    
    @IBOutlet weak var certificationImageTextField: UITextField!
    
    @IBOutlet weak var certificationContentTextView: UITextView!
    
    @IBOutlet weak var uploadImageButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var userManager = UserManager()
    
    var userInfo: UserInfo?
    
    var modifyCertificationIndex: Int?
    
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
        
        uploadImageButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightGary.hexText)
        
        uploadImageButton.cornerRadius = 5
        
        confirmButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        confirmButton.cornerRadius = 5
        
    }
    
    func modifyCertification(index: Int) {
        
        guard let certification = userInfo?.certification[index] else { return }
        
        certificationTitleTextField.text = certification.title
        
        certificationImageTextField.text = certification.imageLink
        
        certificationContentTextView.text = certification.content

    }

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
              certificationTitleTextField.text != "" else {
            
                  HUD.flash(.label(InputError.titleEmpty.title), delay: 0.5)
                  
            return
            
        }
        
        guard let certificationImage = certificationImageTextField.text,
              certificationImageTextField.text != "" else {
            
            HUD.flash(.label("請上傳認證照！"), delay: 0.5)
            
            return
            
        }
        
        guard let certificationContent = certificationContentTextView.text,
              certificationContentTextView.text != "" else {
            
            HUD.flash(.label(InputError.contentEmpty.title), delay: 0.5)
            
            return
            
        }
        
        if var userInfo = self.userInfo {
            
            if modifyCertificationIndex == nil {
                
                let createTime = TimeInterval(Int(Date().timeIntervalSince1970))
                
                userInfo.certification.append(Certification(
                    createTime: createTime, title: certificationTitle, imageLink: certificationImage, content: certificationContent))
                
                HUD.flash(.labeledSuccess(title: "新增成功！", subtitle: nil), delay: 0.5)
                
            } else {
                
                let index = modifyCertificationIndex ?? 0
                
                userInfo.certification[index].title = certificationTitle
                
                userInfo.certification[index].imageLink = certificationImage
                
                userInfo.certification[index].content = certificationContent
                
                HUD.flash(.labeledSuccess(title: "修改成功！", subtitle: nil), delay: 0.5)
                
            }

            userManager.updateData(user: userInfo)
            
            self.navigationController?.isNavigationBarHidden = false
            
            self.view.removeFromSuperview()
            
        }
        
    }
    
}

extension PublishCertificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let strongSelf = self else { return }

                switch result {

                case.success(let imageLink):

                    strongSelf.certificationImageTextField.text = "\(imageLink)"

                case .failure(let error):

                    print(error)
                    
                    HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

                }

            })

        }

        dismiss(animated: true)

    }
    
}

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
