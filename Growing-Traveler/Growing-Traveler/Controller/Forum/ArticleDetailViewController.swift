//
//  ArticleDetailViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/15.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var articleDetailTableView: UITableView! {
        
        didSet {
            
            articleDetailTableView.delegate = self
            
            articleDetailTableView.dataSource = self
            
        }
        
    }
    
    var forumArticle: ForumArticle?
    
    var formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleDetailTableView.register(
            UINib(nibName: String(describing: ArticleDetailHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: ArticleDetailHeaderView.self)
        )
        
    }

}

extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: ArticleDetailHeaderView.self))

        guard let headerView = headerView as? ArticleDetailHeaderView else { return headerView }
        
        headerView.titleLabel.text = forumArticle?.title
        
        headerView.categoryLabel.text = forumArticle?.category.title
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let createTime = Date(
            timeIntervalSince1970: forumArticle?.createTime ?? TimeInterval()
        )
        
        headerView.createTimeLabel.text = formatter.string(from: createTime)
        
        print("TESTTT \(forumArticle?.forumType)")
        
        headerView.forumTypeLabel.text = forumArticle?.forumType
        
        headerView.userIDLabel.text = userID
        
        return headerView
        
    }
    
}
