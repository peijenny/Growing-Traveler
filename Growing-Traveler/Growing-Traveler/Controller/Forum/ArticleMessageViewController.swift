//
//  ArticleMessageViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/16.
//

import UIKit
import PKHUD

class ArticleMessageViewController: BaseViewController {

    @IBOutlet weak var messageTextField: UITextField!
    
    var forumArticleManager = ForumArticleManager()
    
    var articleID = String()
    
    var orderID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func selectImageButton(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        guard let contentText = messageTextField.text else { return }
        
        if contentText == "" {
            
            HUD.flash(.label("留言不可為空！"), delay: 0.5)
            
        } else {

            var contentType = ""

            if contentText.range(of: "https://i.imgur.com") != nil {

                contentType = "image"

            } else {

                contentType = "string"

            }

            let message = ArticleContent(
                orderID: orderID,
                contentType: contentType,
                contentText: contentText
            )

            let articleMessage = ArticleMessage(
                userID: userID,
                articleID: articleID,
                createTime: TimeInterval(Int(Date().timeIntervalSince1970)),
                message: message
            )

            forumArticleManager.addMessageData(articleMessage: articleMessage)

            self.view.removeFromSuperview()
            
        }
        
    }
    
}

extension ArticleMessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let strongSelf = self else { return }

                switch result {

                case.success(let imageLink):

                    strongSelf.messageTextField.text = "\(imageLink)"

                case .failure(let error):

                    print(error)

                }

            })

        }

        dismiss(animated: true)

    }
    
}
