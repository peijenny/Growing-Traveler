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
    
    var userManager = UserManager()
    
    var usersInfo: [UserInfo] = []
    
    var forumArticles: [ForumArticle] = [] {
        
        didSet {
            
            moreArticlesTableView.reloadData()
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "E6EBF6")
        
        if let forumType = forumType {
            
            title = "更多\(forumType)"
            
        }
        
        fetchData()
        
        setTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserInfoData()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func fetchUserInfoData() {
        
        userManager.fetchUsersData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let usersInfo):
                
                strongSelf.usersInfo = usersInfo
                
                strongSelf.moreArticlesTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
            }
            
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
            moreArticlesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            moreArticlesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
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
        
        cell.selectionStyle = .none
        
        let userInfo = usersInfo.filter({ $0.userID == forumArticles[indexPath.row].userID })
        
        if userInfo.count != 0 {
            
            let userName = userInfo[0].userName
            
            cell.showMoreArticles(
                forumArticle: forumArticles[indexPath.row],
                userName: userName
            )
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = ArticleDetailViewController()
        
        viewController.forumArticle = forumArticles[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
}
