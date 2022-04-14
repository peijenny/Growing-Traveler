//
//  PublishForumArticleViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit
import JXPhotoBrowser

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

    var imageLink: String? {
        
        didSet {
        
            publishArticleTableView.reloadData()
            
        }
        
    }
    
    var contentArray: [String] = []
    
    var checkArticleFullIn = false
    
    var forumArticleManager = ForumArticleManager()
    
    var inputTitle: String?
    
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
        
        if contentArray != [] {
            
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
                
            }
            
            guard let inputTitle = inputTitle else { return }
            
            guard let selectCategoryItem = selectCategoryItem else { return }
            
            let forumArticle = ForumArticle(
                id: forumArticleManager.database.document().documentID,
                userID: userID,
                createTime: TimeInterval(Int(Date().timeIntervalSince1970)),
                title: inputTitle,
                category: selectCategoryItem,
                content: articleContents
            )

            forumArticleManager.addData(forumArticle: forumArticle)
            
            navigationController?.popViewController(animated: true)

        }
        
        checkArticleFullIn = false

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
                    
                    inputTitle = cell.titleTextField.text
                    
                }

            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PublishArticleContentTableViewCell.self),
                for: indexPath
            )

            guard let cell = cell as? PublishArticleContentTableViewCell else { return cell }

            cell.addImageButton.addTarget(self, action: #selector(insertImage), for: .touchUpInside)
            
            if checkArticleFullIn {

                if cell.checkInput() != [] {
                    
                    contentArray = cell.checkInput()
                    
                    handleArticleContentData()
                    
                }
                
            }
            
            if let imageLink = self.imageLink {
                
                cell.insertPictureToTextView(imageLink: imageLink)
                
                self.imageLink = nil
                
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
        
//        if let image = info[.originalImage] as? UIImage {
//
//            let uploadImageManager = UploadImageManager()
//
//            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in
//
//                guard let strongSelf = self else { return }
//
//                switch result {
//
//                case.success(let imageLink):
//
//                    strongSelf.imageLink = imageLink
//
//                case .failure(let error):
//
//                    print(error)
//
//                }
//
//            })
//
//        }
        
        imageLink = "https://i.imgur.com/svlrAtw.jpeg"

        dismiss(animated: true)

    }
    
}
