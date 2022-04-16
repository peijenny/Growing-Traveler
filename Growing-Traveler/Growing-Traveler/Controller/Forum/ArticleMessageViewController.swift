//
//  ArticleMessageViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/16.
//

import UIKit

class ArticleMessageViewController: BaseViewController {

    @IBOutlet weak var messageTextField: UITextField!
    
    var forumArticleManager = ForumArticleManager()
    
    var articleID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        var contentType = ""
        
        if contentText.range(of: "https://") != nil {
            
            contentType = "image"
            
        } else {
            
            contentType = "string"
            
        }
        
        let message = ArticleContent(
            orderID: 0,
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
