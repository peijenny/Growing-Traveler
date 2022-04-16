//
//  MoreArticlesViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/15.
//

import UIKit

class MoreArticlesViewController: UIViewController {
    
    var moreArticlesTableView = UITableView()
    
    var forumType: String?
    
    var forumArticleManager = ForumArticleManager()
    
    var forumArticles: [ForumArticle] = [] {
        
        didSet {
            
            moreArticlesTableView.reloadData()
            
        }
        
    }
    
    var formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        if let forumType = forumType {
            
            title = "更多\(forumType)"
            
        }
        
        fetchData()
        
        setTableView()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func fetchData() {
        
        forumArticleManager.fetchData(forumType: forumType ?? "", completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):

                strongSelf.forumArticles = data
                
            case .failure(let error):
                
                print(error)
                
            }
            
        })
        
    }
    
    func setTableView() {
        
        moreArticlesTableView.backgroundColor = UIColor.clear
        
        moreArticlesTableView.separatorStyle = .none
        
        view.addSubview(moreArticlesTableView)
        
        moreArticlesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moreArticlesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            moreArticlesTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            moreArticlesTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            moreArticlesTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -160.0)
        ])
        
        moreArticlesTableView.register(
            UINib(nibName: String(describing: MoreArticlesTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: MoreArticlesTableViewCell.self)
        )

        moreArticlesTableView.delegate = self
        
        moreArticlesTableView.dataSource = self
        
    }

}

extension MoreArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forumArticles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MoreArticlesTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? MoreArticlesTableViewCell else { return cell }
        
        cell.checkImage(forumArticle: forumArticles[indexPath.row])

        cell.titleLabel.text = forumArticles[indexPath.row].title
        
        cell.forumTypeLabel.text = forumArticles[indexPath.row].forumType

        cell.categoryLabel.text = forumArticles[indexPath.row].category.title
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let createTime = Date(timeIntervalSince1970: forumArticles[indexPath.row].createTime)
        
        cell.createTimeLabel.text = formatter.string(from: createTime)

        cell.userIDLabel.text = userID
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = ArticleDetailViewController()
        
        viewController.forumArticle = forumArticles[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
}
