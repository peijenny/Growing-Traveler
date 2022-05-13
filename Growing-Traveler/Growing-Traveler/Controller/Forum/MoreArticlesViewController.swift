//
//  MoreArticlesViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/15.
//

import UIKit
import PKHUD

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
    
    var friendManager = FriendManager()
    
    var blockadeList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let forumType = forumType {
            
            title = "更多\(forumType)"
            
        }
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        setBackgroundView()
        
        setTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserInfoData()
        
        fetchFriendBlockadeListData()
        
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
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func fetchFriendBlockadeListData() {
        
        friendManager.fetchFriendListData(
        fetchUserID: userID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let userFriend):
                
                strongSelf.blockadeList = userFriend.blockadeList
                
                strongSelf.fetchData()
                
                strongSelf.moreArticlesTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
                
        }
        
    }
    
    func fetchData() {
        
        forumArticleManager.fetchData(forumType: forumType ?? "") { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                var filterData = data
                
                if strongSelf.blockadeList != [] {
                    
                    for index in 0..<strongSelf.blockadeList.count {
                        
                        filterData = filterData.filter({ $0.userID != strongSelf.blockadeList[index] })
                        
                    }
                    
                }

                strongSelf.forumArticles = filterData
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func setBackgroundView() {
        
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightGary.hexText)
        
        view.addSubview(backgroundView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
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
            moreArticlesTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -110.0)
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
            
            cell.showMoreArticles(forumArticle: forumArticles[indexPath.row], userName: userName)
            
        }

        cell.userInfoButton.addTarget(self, action: #selector(showUserInfoButton), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func showUserInfoButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: moreArticlesTableView)

        if let indexPath = moreArticlesTableView.indexPathForRow(at: point) {
            
            guard let viewController = UIStoryboard.chat.instantiateViewController(
                withIdentifier: String(describing: UserInfoViewController.self)
            ) as? UserInfoViewController else { return }
            
            viewController.deleteAccount = false
            
            viewController.selectUserID = forumArticles[indexPath.row].userID
            
            viewController.articleID = forumArticles[indexPath.row].id
            
            viewController.reportContentType = ReportContentType.article.title
            
            viewController.blockContentType = BlockContentType.article.title
            
            viewController.getFriendStatus = { [weak self] isBlock in
                
                guard let strongSelf = self else { return }
                
                if isBlock {
                    
                    strongSelf.forumArticles = strongSelf.forumArticles.filter({
                        
                        $0.userID != strongSelf.forumArticles[indexPath.row].userID
                        
                    })
                    
                }
                
            }
            
            self.view.addSubview(viewController.view)

            self.addChild(viewController)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = ArticleDetailViewController()
        
        viewController.forumArticle = forumArticles[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
