//
//  PublishForumArticleViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit

class PublishForumArticleViewController: BaseViewController {

    // MARK: - IBOutlet / Components
    var publishArticleTableView = UITableView()
    
    // MARK: - Property
    var forumArticleManager = ForumArticleManager()
    
    var modifyForumArticle: ForumArticle? {
        
        didSet {
        
            publishArticleTableView.reloadData()
            
        }
        
    }
    
    var selectCategoryItem: CategoryItem? {
        
        didSet {
        
            publishArticleTableView.reloadData()
            
        }
        
    }
    
    var contentArray: [String] = []
    
    var imageLink: String? {
        
        didSet {
        
            publishArticleTableView.reloadData()
            
        }
        
    }
    
    var inputTitle: String?
    
    var forumType: String?
    
    var checkArticleFullIn = false
    
    var isModify = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if modifyForumArticle == nil {
            
            title = "新增發佈"
            
        } else {
            
            title = "修改發佈"
            
            selectCategoryItem = modifyForumArticle?.category
            
        }
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        setTableView()
        
        setNavigationItem()

    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    // MARK: - Set UI
    func setTableView() {
        
        publishArticleTableView.backgroundColor = UIColor.white
        
        publishArticleTableView.separatorStyle = .none
        
        view.addSubview(publishArticleTableView)
        
        publishArticleTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            publishArticleTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            publishArticleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            publishArticleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            publishArticleTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -140.0)
        ])
        
        publishArticleTableView.register(
            UINib(nibName: String(describing: PublishArticleTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: PublishArticleTableViewCell.self)
        )

        publishArticleTableView.delegate = self
        
        publishArticleTableView.dataSource = self
        
    }
    
    func setNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(submitButton))
        
    }
    
    // MARK: - Method
    func handleArticleContentData() {
        
        var articleContents: [ArticleContent] = []
        
        var articleType = String()
        
        if contentArray != [] {
            
            for index in 0..<contentArray.count {
                
                if contentArray[index].range(of: "https://i.imgur.com") != nil {
                    
                    articleType = SendType.image.title
                    
                } else {
                    
                    articleType = SendType.string.title
                    
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
            
            if modifyForumArticle == nil {
                
                let forumID = forumArticleManager.database.document().documentID
                
                let createTime = TimeInterval(Int(Date().timeIntervalSince1970))
                
                let forumArticle = ForumArticle(
                    id: forumID, userID: KeyToken().userID, createTime: createTime, title: inputTitle,
                    category: selectCategoryItem, content: articleContents, forumType: forumType)
                
                forumArticleManager.addData(forumArticle: forumArticle)
                
                HandleResult.addDataSuccess.messageHUD
                
            } else {
                
                guard var modifyForumArticle = modifyForumArticle else { return }
                
                modifyForumArticle.category = selectCategoryItem
                
                modifyForumArticle.title = inputTitle
                
                modifyForumArticle.content = articleContents
                
                modifyForumArticle.forumType = forumType
                
                forumArticleManager.updateArticleData(forumArticle: modifyForumArticle)
                
                HandleResult.updateDataSuccess.messageHUD
                
            }
            
            navigationController?.popViewController(animated: true)

        }
        
        checkArticleFullIn = false

    }
    
    // MARK: - Target / IBAction
    @objc func submitButton(sender: UIButton) {
        
        checkArticleFullIn = true
        
        publishArticleTableView.reloadData()
        
    }

}

// MARK: - TableView delegate / dataSource
extension PublishForumArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PublishArticleTableViewCell.self), for: indexPath)

        guard let cell = cell as? PublishArticleTableViewCell else { return cell }
        
        cell.selectionStyle = .none
        
        cell.contentTextView.delegate = self
        
        cell.categoryLabel.text = selectCategoryItem?.title ?? "請選擇分類標籤"
        
        if cell.categoryLabel.text ?? "" != "請選擇分類標籤" {
            
            cell.categoryLabel.textColor = UIColor.black
            
        }
        
        let categoryTapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(selectCategoryTagButton))
        
        cell.categoryLabel.addGestureRecognizer(categoryTapGestureRecognizer)
        
        cell.selectCategoryButton.addTarget(
            self, action: #selector(selectCategoryTagButton), for: .touchUpInside)
        
        cell.addImageButton.addTarget(
            self, action: #selector(insertImage), for: .touchUpInside)
        
        if modifyForumArticle != nil && !isModify {
            
            isModify = true
            
            if let modifyForumArticle = modifyForumArticle {
                
                cell.modifyForumArticle(modifyForumArticle: modifyForumArticle)
                
                for index in 0..<modifyForumArticle.content.count {
                    
                    contentArray.append(modifyForumArticle.content[index].contentText)
                    
                }

            }
            
        }
        
        if let imageLink = self.imageLink {
            
            cell.insertPictureToTextView(imageLink: imageLink)
            
            self.imageLink = nil
            
        }
        
        if checkArticleFullIn && cell.checkInputType() {
            
            inputTitle = cell.titleTextField.text
            
            forumType = cell.typeSegmentedControl.titleForSegment(
                at: cell.typeSegmentedControl.selectedSegmentIndex)
            
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
        
        if #available(iOS 15.0, *) {

            guard let sheetPresentationController = navController.sheetPresentationController else { return }
            
            sheetPresentationController.detents = [.medium()]

        } else {
            
            navController.modalPresentationStyle = .fullScreen

        }
        
        self.present(navController, animated: true, completion: nil)
        
    }

}

// MARK: - ImagePickerController delegate
extension PublishForumArticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let self = self else { return }

                switch result {

                case.success(let imageLink):

                    self.imageLink = imageLink

                case .failure:

                    HandleResult.readDataFailed.messageHUD
                    
                }

            })

        }

        dismiss(animated: true)

    }
    
}

// MARK: - textView delegate
extension PublishForumArticleViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            
            textView.text = nil
            
            textView.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            
            textView.text = "請描述內容......"
            
            textView.textColor = UIColor.lightGray
            
        }
        
    }
    
}
