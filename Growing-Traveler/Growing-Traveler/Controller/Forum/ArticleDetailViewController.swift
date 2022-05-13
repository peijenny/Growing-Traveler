//
//  ArticleDetailViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/15.
//

import UIKit
import PKHUD

class ArticleDetailViewController: UIViewController {
    
    var articleDetailTableView = UITableView(frame: .zero, style: .grouped)
    
    var forumArticle: ForumArticle?
    
    var formatter = DateFormatter()
    
    var forumArticleManager = ForumArticleManager()
    
    var articleMessages: [ArticleMessage] = []
    
    let displayImageView = UIImageView()
    
    var userManager = UserManager()
    
    var usersInfo: [UserInfo] = []
    
    var friendManager = FriendManager()
    
    var blockadeList: [String] = []
    
    var isBlock = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = forumArticle?.forumType
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        setNavigationItem()
        
        setBackgroundView()
        
        setTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFriendBlockadeListData()
        
        fetchUserInfoData()
        
    }
    
    func setNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.more), style: .plain, target: self, action: #selector(showUserInfoButton))

    }
    
    @objc func showUserInfoButton(sender: UIButton) {
        
        guard let viewController = UIStoryboard.chat.instantiateViewController(
            withIdentifier: String(describing: UserInfoViewController.self)
        ) as? UserInfoViewController else { return }
        
        viewController.deleteAccount = false
        
        viewController.selectUserID = forumArticle?.userID ?? ""
        
        viewController.articleID = forumArticle?.id
        
        viewController.reportContentType = ReportContentType.article.title
        
        viewController.blockContentType = BlockContentType.article.title
        
        self.view.addSubview(viewController.view)

        self.addChild(viewController)
        
        viewController.getFriendStatus = { [weak self] isBlock in
            
            guard let strongSelf = self else { return }
            
            if isBlock {
                
                strongSelf.navigationController?.popViewController(animated: true)
                
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
                
                strongSelf.listenMessageData()
                
                strongSelf.articleDetailTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
                
        }
        
    }
    
    func fetchUserInfoData() {
        
        userManager.fetchUsersData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let usersInfo):
                
                strongSelf.usersInfo = usersInfo
                
                strongSelf.articleDetailTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
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
                    
                    HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                    
                }
            
        })
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
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
        
        articleDetailTableView.backgroundColor = UIColor.white
        
        articleDetailTableView.separatorStyle = .none
        
        view.addSubview(articleDetailTableView)
        
        articleDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            articleDetailTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            articleDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            articleDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            articleDetailTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -110.0)
        ])
        
        articleDetailTableView.register(
            UINib(nibName: String(describing: ArticleDetailHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: ArticleDetailHeaderView.self))
        
        articleDetailTableView.register(
            UINib(nibName: String(describing: ArticleDetailTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ArticleDetailTableViewCell.self))
        
        articleDetailTableView.register(
            UINib(nibName: String(describing: ArticleMessageHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: ArticleMessageHeaderView.self))
        
        articleDetailTableView.register(
            UINib(nibName: String(describing: ArticleMessageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ArticleMessageTableViewCell.self))

        articleDetailTableView.delegate = self
        
        articleDetailTableView.dataSource = self
        
    }

}

extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (section == 0) ? forumArticle?.content.count ?? 0 : articleMessages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ArticleDetailTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? ArticleDetailTableViewCell else { return cell }
            
            guard let forumArticle = forumArticle else { return cell }
            
            cell.setArticleContent(content: forumArticle.content[indexPath.row], isNote: false)
            
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ArticleMessageTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? ArticleMessageTableViewCell else { return cell }
            
            let userInfo = usersInfo.filter({ $0.userID == articleMessages[indexPath.row].userID })
            
            var userName = String()
            
            var isBlock = false
            
            if !userInfo.isEmpty {
                
                userName = userInfo[0].userName
                
                isBlock = (!blockadeList.filter({ $0 == userInfo[0].userID }).isEmpty) ? true : false
                
            } else {
                
                userName = "[帳號已刪除]"

            }
            
            cell.showMessages(articleMessage: articleMessages[indexPath.row],
                articleUserID: forumArticle?.userID ?? "", userName: userName, isBlock: isBlock)
            
            cell.userInfoButton.addTarget(self, action: #selector(showUserInfoData), for: .touchUpInside)
            
            cell.selectionStyle = .none
            
            return cell
            
        }
        
    }
    
    @objc func showUserInfoData(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: articleDetailTableView)

        if let indexPath = articleDetailTableView.indexPathForRow(at: point) {
            
            guard let viewController = UIStoryboard.chat.instantiateViewController(
                withIdentifier: String(describing: UserInfoViewController.self)
            ) as? UserInfoViewController else { return }
            
            viewController.deleteAccount = false
            
            if indexPath.section == 1 {
                
                viewController.selectUserID = articleMessages[indexPath.row].userID
                
                viewController.articleMessage = articleMessages[indexPath.row]
                
                viewController.reportContentType = ReportContentType.message.title
                
                viewController.blockContentType = BlockContentType.message.title
                
                viewController.deleteAccount = (usersInfo.filter({
                   
                    $0.userID == articleMessages[indexPath.row].userID
                    
                }).isEmpty) ? true : false
                
                viewController.getFriendStatus = { [weak self] isBlock in
                    
                    guard let strongSelf = self else { return }
                    
                    if isBlock {
                        
                        if viewController.selectUserID == strongSelf.forumArticle?.userID {
                            
                            strongSelf.navigationController?.popViewController(animated: true)
                            
                        }
                        
                        strongSelf.fetchFriendBlockadeListData()
                        
                        strongSelf.articleDetailTableView.reloadData()
                        
                    }
                    
                }
                
                self.view.addSubview(viewController.view)

                self.addChild(viewController)
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let forumArticle = forumArticle else { return }
        
        if indexPath.section == 0 && forumArticle.content[indexPath.row].contentType == SendType.image.title {
            
            displayImageView.loadImage(forumArticle.content[indexPath.row].contentText)
            
            displayImageView.showPhoto(imageView: displayImageView)
            
        } else if indexPath.section == 1 && articleMessages[indexPath.row].message.contentType == SendType.image.title {
            
            displayImageView.loadImage(articleMessages[indexPath.row].message.contentText)
            
            displayImageView.showPhoto(imageView: displayImageView)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: ArticleDetailHeaderView.self))

            guard let headerView = headerView as? ArticleDetailHeaderView else { return headerView }
            
            guard let forumArticle = forumArticle else { return headerView }
            
            let userInfo = usersInfo.filter({ $0.userID == forumArticle.userID })

            if !userInfo.isEmpty {
             
                let userName = userInfo[0].userName

                headerView.showArticleDetail(forumArticle: forumArticle, userName: userName)
                
            }
            
            return headerView
            
        } else {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: ArticleMessageHeaderView.self))

            guard let headerView = headerView as? ArticleMessageHeaderView else { return headerView }
            
            headerView.shareToFriendButton.addTarget(
                self, action: #selector(shareToFriendButton), for: .touchUpInside)
            
            headerView.sendMessageButton.addTarget(
                self, action: #selector(sendMessageButton), for: .touchUpInside)
            
            return headerView
            
        }
        
    }
    
    @objc func sendMessageButton(sender: UIButton) {
        
        guard userID != "" else {

            guard let authViewController = UIStoryboard.auth.instantiateViewController(
                withIdentifier: String(describing: AuthenticationViewController.self)
            ) as? AuthenticationViewController else { return }
            
            authViewController.modalPresentationStyle = .formSheet

            present(authViewController, animated: true, completion: nil)

            return
            
        }
        
        guard let viewController = UIStoryboard.forum.instantiateViewController(
            withIdentifier: String(describing: ArticleMessageViewController.self)
        ) as? ArticleMessageViewController else { return }
        
        viewController.articleID = forumArticle?.id ?? ""
        
        viewController.orderID = articleMessages.count
        
        self.navigationController?.isNavigationBarHidden = true

        self.view.addSubview(viewController.view)

        self.addChild(viewController)
        
    }
    
    @objc func shareToFriendButton(sender: UIButton) {
        
        let viewController = ShareToFriendViewController()
        
        viewController.shareType = SendType.articleID.title
        
        viewController.shareID = forumArticle?.id
        
        let navController = UINavigationController(rootViewController: viewController)
        
        if #available(iOS 15.0, *) {
            
            if let sheetPresentationController = navController.sheetPresentationController {
                
                sheetPresentationController.detents = [.medium()]
                
            }
            
        } else {

            navController.modalPresentationStyle = .fullScreen
            
        }
        
        present(navController, animated: true)
        
    }
    
}
