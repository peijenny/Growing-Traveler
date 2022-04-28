//
//  PublishForumArticleViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit
import JXPhotoBrowser

class PublishForumArticleViewController: BaseViewController {

    var publishArticleTableView = UITableView()
    
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
    
    var forumType: String?
    
    var modifyForumArticle: ForumArticle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        title = "新增發佈"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(submitButton)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        setTableView()

    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
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
                
                if contentArray[index].range(of: "https://i.imgur.com") != nil {
                    
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
            
            guard let forumType = forumType else { return }
            
            let forumArticle = ForumArticle(
                id: forumArticleManager.database.document().documentID,
                userID: userID,
                createTime: TimeInterval(Int(Date().timeIntervalSince1970)),
                title: inputTitle,
                category: selectCategoryItem,
                content: articleContents,
                forumType: forumType
            )

            forumArticleManager.addData(forumArticle: forumArticle)
            
            navigationController?.popViewController(animated: true)

        }
        
        checkArticleFullIn = false

    }
    
    func setTableView() {
        
        publishArticleTableView.backgroundColor = UIColor.clear
        
        publishArticleTableView.separatorStyle = .none
        
        view.addSubview(publishArticleTableView)
        
        publishArticleTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            publishArticleTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            publishArticleTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            publishArticleTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            publishArticleTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -160.0)
        ])
        
        publishArticleTableView.register(
            UINib(nibName: String(describing: PublishArticleTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: PublishArticleTableViewCell.self)
        )

        publishArticleTableView.delegate = self
        
        publishArticleTableView.dataSource = self
        
    }

}

extension PublishForumArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PublishArticleTableViewCell.self),
            for: indexPath
        )

        guard let cell = cell as? PublishArticleTableViewCell else { return cell }
        
        cell.selectionStyle = .none
        
        cell.contentTextView.delegate = self
        
        cell.categoryTextField.text = selectCategoryItem?.title
        
        cell.selectCategoryButton.addTarget(
            self, action: #selector(selectCategoryTagButton), for: .touchUpInside)
        
        cell.addImageButton.addTarget(
            self, action: #selector(insertImage), for: .touchUpInside)
        
        if let imageLink = self.imageLink {
            
            cell.insertPictureToTextView(imageLink: imageLink)
            
            self.imageLink = nil
            
        }
        
        if checkArticleFullIn && cell.checkInputType() {
            
            inputTitle = cell.titleTextField.text
            
            forumType = cell.typeSegmentedControl.titleForSegment(
                at: cell.typeSegmentedControl.selectedSegmentIndex
            )
            
            if cell.checkInputContent() != [] {
                
                contentArray = cell.checkInputContent()
                
                handleArticleContentData()
                
            }
            
        }
        
        return cell
        
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
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let strongSelf = self else { return }

                switch result {

                case.success(let imageLink):

                    strongSelf.imageLink = imageLink

                case .failure(let error):

                    print(error)

                }

            })

        }

        dismiss(animated: true)

    }
    
}

extension PublishForumArticleViewController: UITextViewDelegate {
    
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
