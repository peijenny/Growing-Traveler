//
//  ArticleMessageViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/16.
//

import UIKit

class ArticleMessageViewController: BaseViewController {

    // MARK: - IBOutlet / Components
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var selectImageButton: UIButton!
    
    // MARK: - Property
    var forumArticleManager = ForumArticleManager()
    
    var articleID = String()
    
    var orderID = Int()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        submitButton.cornerRadius = 5
        
        selectImageButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)

        selectImageButton.cornerRadius = 5
        
    }

    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    // MARK: - Target / IBAction
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func selectImageButton(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        guard let contentText = messageTextField.text else { return }
        
        if contentText.isEmpty {
            
            HandleInputResult.messageEmpty.messageHUD
            
        } else {

            let contentType = (contentText.range(of: "https://i.imgur.com") != nil) ?
            SendType.image.title : SendType.string.title
            
            let createTime = TimeInterval(Int(Date().timeIntervalSince1970))

            let message = ArticleContent(
                orderID: orderID, contentType: contentType, contentText: contentText)

            let articleMessage = ArticleMessage(
                userID: KeyToken().userID, articleID: articleID, createTime: createTime, message: message)

            forumArticleManager.addMessageData(articleMessage: articleMessage)
            
            self.navigationController?.isNavigationBarHidden = false

            self.view.removeFromSuperview()
            
        }
        
    }
    
}

// MARK: - ImageViewController delegate
extension ArticleMessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let self = self else { return }

                switch result {

                case.success(let imageLink):

                    self.messageTextField.text = "\(imageLink)"

                case .failure:
                    
                    HandleResult.readDataFailed.messageHUD

                }

            })

        }

        dismiss(animated: true)

    }
    
}
