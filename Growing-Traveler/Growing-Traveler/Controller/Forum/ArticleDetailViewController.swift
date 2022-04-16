//
//  ArticleDetailViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/15.
//

import UIKit
import JXPhotoBrowser

class ArticleDetailViewController: UIViewController {
    
    var articleDetailTableView = UITableView(frame: .zero, style: .grouped)
    
    var forumArticle: ForumArticle? {
        
        didSet {
            
          articleDetailTableView.reloadData()
            
        }
    }
    
    var formatter = DateFormatter()
    
    var forumArticleManager = ForumArticleManager()
    
    var articleMessages: [ArticleMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = forumArticle?.forumType
        
        setTableView()
        
        listenMessageData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .compose,
            target: self,
            action: #selector(sendMessageButton)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black

    }
    
    func listenMessageData() {
        
        guard let articleID = forumArticle?.id else { return }
        
        forumArticleManager.listenMessageData(
            articleID: articleID,
            completion: { [weak self] result in
                
                guard let strongSelf = self else { return }
            
                switch result {
                    
                case .success(let data):
                    
                    strongSelf.articleMessages = data
                    
                    strongSelf.articleDetailTableView.reloadData()
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
            
        })
    }
    
    @objc func sendMessageButton(sender: UIButton) {
        
        guard let viewController = UIStoryboard
            .forum
            .instantiateViewController(
                withIdentifier: String(describing: ArticleMessageViewController.self)
                ) as? ArticleMessageViewController else {

                    return

                }
        
        viewController.articleID = forumArticle?.id ?? ""
        
        viewController.orderID = articleMessages.count

        self.view.addSubview(viewController.view)

        self.addChild(viewController)
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func setTableView() {
        
        articleDetailTableView.backgroundColor = UIColor.clear
        
        articleDetailTableView.separatorStyle = .none
        
        view.addSubview(articleDetailTableView)
        
        articleDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            articleDetailTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            articleDetailTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            articleDetailTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            articleDetailTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -160.0)
        ])
        
        articleDetailTableView.register(
            UINib(nibName: String(describing: ArticleDetailHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: ArticleDetailHeaderView.self)
        )
        
        articleDetailTableView.register(
            UINib(nibName: String(describing: ArticleDetailTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ArticleDetailTableViewCell.self)
        )
        
        articleDetailTableView.register(
            UINib(nibName: String(describing: ArticleMessageHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: ArticleMessageHeaderView.self)
        )
        
        articleDetailTableView.register(
            UINib(nibName: String(describing: ArticleMessageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ArticleMessageTableViewCell.self)
        )

        articleDetailTableView.delegate = self
        
        articleDetailTableView.dataSource = self
        
    }

}

extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return forumArticle?.content.count ?? 0
            
        } else {
            
            return articleMessages.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ArticleDetailTableViewCell.self),
                for: indexPath
            )
            
            guard let cell = cell as? ArticleDetailTableViewCell else { return cell }
            
            guard let forumArticle = forumArticle else { return cell }
            
            cell.setArticleContent(content: forumArticle.content[indexPath.row])
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ArticleMessageTableViewCell.self),
                for: indexPath
            )
            
            guard let cell = cell as? ArticleMessageTableViewCell else { return cell }
            
            cell.showMessages(articleMessage: articleMessages[indexPath.row])
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myImageView = UIImageView()
        
        guard let forumArticle = forumArticle else { return }
        
        if indexPath.section == 0 && forumArticle.content[indexPath.row].contentType == "image" {
            
            myImageView.loadImage(forumArticle.content[indexPath.row].contentText)
            
        } else if indexPath.section == 1 && articleMessages[indexPath.row].message.contentType == "image" {
            
            myImageView.loadImage(articleMessages[indexPath.row].message.contentText)
            
        }
        
        // 展示 image (pop-up Image 單獨顯示的視窗)
        let browser = JXPhotoBrowser()

        browser.numberOfItems = { 1 }

        browser.reloadCellAtIndex = { context in

            let browserCell = context.cell as? JXPhotoBrowserImageCell
            
            browserCell?.imageView.image = myImageView.image
            
        }

        browser.show()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: ArticleDetailHeaderView.self))

            guard let headerView = headerView as? ArticleDetailHeaderView else { return headerView }
            
            guard let forumArticle = forumArticle else { return headerView }
            
            headerView.showArticleDetail(forumArticle: forumArticle)
            
            return headerView
            
        } else {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: ArticleMessageHeaderView.self))

            guard let headerView = headerView as? ArticleMessageHeaderView else { return headerView }
            
            return headerView
        }
        
    }
    
}
