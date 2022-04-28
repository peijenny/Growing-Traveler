//
//  ReleaseRecordViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/28.
//

import UIKit

class ReleaseRecordViewController: UIViewController {

    var releaseRecordTableView = UITableView()
    
    var forumArticleManager = ForumArticleManager()
    
    var forumArticles: [ForumArticle] = [] {
        
        didSet {
            
            releaseRecordTableView.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "發佈文章紀錄"
        
        self.view.backgroundColor = UIColor.white

        setTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchReleaseData()
        
    }
    
    func fetchReleaseData() {
        
        forumArticleManager.fetchSearchData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let forumArticles):
                
                let filterArticles = forumArticles.filter({ $0.userID == userID })
                
                strongSelf.forumArticles = filterArticles
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
    }

    func setTableView() {
        
        releaseRecordTableView.backgroundColor = UIColor.clear
        
        view.addSubview(releaseRecordTableView)
        
        releaseRecordTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            releaseRecordTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            releaseRecordTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            releaseRecordTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            releaseRecordTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -160.0)
        ])
        
        releaseRecordTableView.register(
            UINib(nibName: String(describing: MoreArticlesTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: MoreArticlesTableViewCell.self)
        )

        releaseRecordTableView.delegate = self
        
        releaseRecordTableView.dataSource = self
        
    }

}

extension ReleaseRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        cell.selectionStyle = .none
        
        cell.showMoreArticles(forumArticle: forumArticles[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = PublishForumArticleViewController()
        
        viewController.modifyForumArticle = forumArticles[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
