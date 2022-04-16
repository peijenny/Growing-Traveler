//
//  ArticleDetailViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/15.
//

import UIKit
import JXPhotoBrowser

class ArticleDetailViewController: UIViewController {
    
    var articleDetailTableView = UITableView()
    
    var forumArticle: ForumArticle? {
        
        didSet {
            
          articleDetailTableView.reloadData()
            
        }
    }
    
    var formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .compose,
            target: self,
            action: #selector(sendMessageButton)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black

    }
    
    @objc func sendMessageButton(sender: UIButton) {
        
        guard let selectStudyItemViewController = UIStoryboard
            .forum
            .instantiateViewController(
                withIdentifier: String(describing: ArticleMessageViewController.self)
                ) as? ArticleMessageViewController else {

                    return

                }

        self.view.addSubview(selectStudyItemViewController.view)

        self.addChild(selectStudyItemViewController)
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func setTableView() {
        
        articleDetailTableView.separatorStyle = .none
        
        view.addSubview(articleDetailTableView)
        
        articleDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            articleDetailTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0),
            articleDetailTableView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            articleDetailTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            articleDetailTableView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        articleDetailTableView.register(
            UINib(nibName: String(describing: ArticleDetailHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: ArticleDetailHeaderView.self)
        )
        
        articleDetailTableView.register(
            UINib(nibName: String(describing: ArticleDetailTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ArticleDetailTableViewCell.self)
        )

        articleDetailTableView.delegate = self
        
        articleDetailTableView.dataSource = self
        
    }

}

extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forumArticle?.content.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ArticleDetailTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? ArticleDetailTableViewCell else { return cell }
        
        guard let forumArticle = forumArticle else { return cell }
        
        cell.setArticleContent(content: forumArticle.content[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let forumArticle = forumArticle else { return }
        
        if forumArticle.content[indexPath.row].contentType == "image" {
            
            let myImageView = UIImageView()
            
            myImageView.loadImage(forumArticle.content[indexPath.row].contentText)
            
            // 展示 image (pop-up Image 單獨顯示的視窗)
            let browser = JXPhotoBrowser()

            browser.numberOfItems = { 1 }

            browser.reloadCellAtIndex = { context in

                let browserCell = context.cell as? JXPhotoBrowserImageCell
                
                browserCell?.imageView.image = myImageView.image
                
            }

            browser.show()
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: ArticleDetailHeaderView.self))

        guard let headerView = headerView as? ArticleDetailHeaderView else { return headerView }
        
        guard let forumArticle = forumArticle else { return headerView }
        
        headerView.titleLabel.text = forumArticle.title
        
        headerView.categoryLabel.text = forumArticle.category.title
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let createTime = Date(timeIntervalSince1970: forumArticle.createTime)
        
        headerView.createTimeLabel.text = formatter.string(from: createTime)
        
        headerView.forumTypeLabel.text = forumArticle.forumType
        
        headerView.userIDLabel.text = userID
        
        tableView.tableHeaderView = UIView.init(
            frame: CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        )
        
        tableView.contentInset = UIEdgeInsets.init(
            top: -headerView.frame.height, left: 0, bottom: 0, right: 0
        )

        return headerView
        
    }
    
}
