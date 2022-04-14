//
//  PublishForumArticleViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit
import JXPhotoBrowser
import Alamofire

class PublishForumArticleViewController: UIViewController {

    @IBOutlet weak var publishArticleTableView: UITableView! {
        
        didSet {
            
            publishArticleTableView.delegate = self
            
            publishArticleTableView.dataSource = self
            
        }
        
    }
    
    var selectCategoryItem: CategoryItem? {
        
        didSet {
        
            publishArticleTableView.reloadData()
            
        }
        
    }
    
    var image: UIImage?
    
    var imageString: String? {
        
        didSet {
        
            publishArticleTableView.reloadData()
            
        }
        
    }
    
    var forumArticle: ForumArticle?
    
    var contentArray: [String] = []
    
    var checkArticleFullIn = false
    
    var forumArticleManager = ForumArticleManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishArticleTableView.register(
            UINib(nibName: String(describing: PublishArticleTypeTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: PublishArticleTypeTableViewCell.self)
        )
        
        publishArticleTableView.register(
            UINib(nibName: String(describing: PublishArticleContentTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: PublishArticleContentTableViewCell.self)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(submitButton)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black

    }
    
    @objc func submitButton(sender: UIButton) {
        
        checkArticleFullIn = true
        
        publishArticleTableView.reloadData()
        
    }
    
    func handleArticleContentData() {
        
        var articleContents: [ArticleContent] = []
        
        var articleType = String()

        for index in 0..<contentArray.count {
            
            if contentArray[index].range(of: "https://") != nil {
                
                articleType = "image"
                
            } else {
                
                articleType = "string"
                
            }
            
            articleContents.append(ArticleContent(
                orderID: index,
                contentType: articleType,
                contentText: contentArray[index]
                ))
            
            forumArticle?.content = articleContents
            
        }
        
        guard let forumArticle = forumArticle else { return }

        forumArticleManager.addData(forumArticle: forumArticle)
        
        navigationController?.popViewController(animated: true)
    }

}

extension PublishForumArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PublishArticleTypeTableViewCell.self),
                for: indexPath
            )

            guard let cell = cell as? PublishArticleTypeTableViewCell else { return cell }
            
            cell.selectCategoryButton.addTarget(
                self, action: #selector(selectCategoryTagButton), for: .touchUpInside)
            
            cell.categoryTextField.text = selectCategoryItem?.title
            
            if checkArticleFullIn {
                
                if cell.checkInput() {
                    
                    guard let inputTitle = cell.titleTextField.text else { return cell }
                    
                    guard let selectCategoryItem = selectCategoryItem else { return cell }
                    
                    forumArticle = ForumArticle(
                        id: forumArticleManager.database.document().documentID,
                        userID: userID,
                        createTime: TimeInterval(Int(Date().timeIntervalSince1970)),
                        title: inputTitle,
                        category: selectCategoryItem,
                        content: [ArticleContent]()
                    )
                    
                    handleArticleContentData()
                    
                }

                checkArticleFullIn = false
                
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PublishArticleContentTableViewCell.self),
                for: indexPath
            )

            guard let cell = cell as? PublishArticleContentTableViewCell else { return cell }

            cell.addImageButton.addTarget(self, action: #selector(insertImage), for: .touchUpInside)
            
            guard let imageString = imageString else { return cell }
            
            cell.insertPictureToTextView(imageString: imageString)
            
            if contentArray == [] {
                
                contentArray.append(cell.contentTextView.text)
                
            } else if contentArray != [] && !checkArticleFullIn {
                
                contentArray = cell.contentTextView
                    .attributedText.string.split(separator: "\0").map({ String($0) })
                
            }

            return cell
            
        }
        
    }
    
    @objc func insertImage(sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
    @objc func selectCategoryTagButton(sender: UIButton) {
        
        let categoryViewController = SelectCategoryViewController()
        
        categoryViewController.getSelectCategoryItem = { [weak self] item in
            
            self?.selectCategoryItem = item
            
        }
        
        let navController = UINavigationController(rootViewController: categoryViewController)
        
        if let sheetPresentationController = navController.sheetPresentationController {
            
            sheetPresentationController.detents = [.medium()]
            
        }
        
        self.present(navController, animated: true, completion: nil)
        
    }

}

extension PublishForumArticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        image = info[.originalImage] as? UIImage
//
//        if let image = info[.originalImage] as? UIImage {
//
//            uploadImage(uiImage: image)
//
//
//        }

        imageString = "https://i.imgur.com/4KuCb34.jpeg"
        
        dismiss(animated: true)

    }
    
    func uploadImage(uiImage: UIImage) {
        
        let headers: HTTPHeaders = ["Authorization": "Client-ID fbe53d91453b687"]
        
        AF.upload(multipartFormData: { data in
            
            if let imageData = uiImage.jpegData(compressionQuality: 0.9) {
                
                data.append(imageData, withName: "image")
                
            }
            
        }, to: "https://api.imgur.com/3/image", headers: headers
        ).responseDecodable(
            of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()
        ) { [weak self] response in
            
            guard let strongSelf = self else { return }
            
            switch response.result {
                
            case .success(let result):
                
                print("TEST \(result.data.link)")
                
                strongSelf.imageString = "\(result.data.link)"
                
            case .failure(let error):
                
                print(error)
            }
            
        }
        
    }
    
}
