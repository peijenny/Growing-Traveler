//
//  MoreArticlesViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/15.
//

import UIKit

class MoreArticlesViewController: UIViewController {
    
    @IBOutlet weak var moreArticlesTableView: UITableView! {
        
        didSet {
            
            moreArticlesTableView.delegate = self
            
            moreArticlesTableView.dataSource = self
            
        }
        
    }
    
    var forumType: String?
    
    var forumArticleManager = ForumArticleManager()
    
    var forumArticles: [ForumArticle] = [] {
        
        didSet {
            
            moreArticlesTableView.reloadData()
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        moreArticlesTableView.register(
            UINib(nibName: String(describing: MoreArticlesTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: MoreArticlesTableViewCell.self)
        )
        
    }
    
    func fetchData() {
        
        forumArticleManager.fetchData(forumType: forumType ?? "", completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):

                strongSelf.forumArticles = data
                
                print("TEST \(data)")
                
            case .failure(let error):
                
                print(error)
                
            }
            
        })
        
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

        cell.userIDLabel.text = userID
        
        return cell
        
    }
    
    
    
}
