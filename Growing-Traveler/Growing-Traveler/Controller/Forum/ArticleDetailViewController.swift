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
    
    var forumArticle: ForumArticle?
    
    var formatter = DateFormatter()
    
    var forumArticleManager = ForumArticleManager()
    
    var articleMessages: [ArticleMessage] = []
    
    let myImageView = UIImageView()
    
    var userManager = UserManager()
    
    var usersInfo: [UserInfo] = []
    
    var friendManager = FriendManager()
    
    var blockadeList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = forumArticle?.forumType
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        setBackgroundView()
        
        setTableView()
        
        setNavigationItems()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFriendBlockadeListData()
        
    }
    
    func setNavigationItems() {
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage.asset(.edit), style: .plain, target: self, action: #selector(sendMessageButton)),
            UIBarButtonItem(
                image: UIImage.asset(.share), style: .plain, target: self, action: #selector(shareToFriendButton))
        ]
        
        navigationItem.rightBarButtonItems?[0].tintColor = UIColor.black

        navigationItem.rightBarButtonItems?[1].tintColor = UIColor.black
        
        navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
    }
    
    func fetchFriendBlockadeListData() {
        
        friendManager.fetchFriendListData(
        fetchUserID: userID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let userFriend):
                
                strongSelf.blockadeList = userFriend.blockadeList
                
                strongSelf.listenMessageData()
                
                strongSelf.fetchUserInfoData()
                
                strongSelf.articleDetailTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
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
                    
                }
            
        })
    }
    
    @objc func sendMessageButton(sender: UIButton) {
        
        guard userID != "" else {

            guard let authViewController = UIStoryboard.auth.instantiateViewController(
                    withIdentifier: String(describing: AuthenticationViewController.self)
                    ) as? AuthenticationViewController else { return }
            
            authViewController.modalPresentationStyle = .popover

            present(authViewController, animated: true, completion: nil)

            return
        }
        
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
    
    @objc func shareToFriendButton(sender: UIButton) {
        
        let viewController = ShareToFriendViewController()
        
        viewController.shareType = SendType.articleID.title
        
        viewController.shareID = forumArticle?.id
        
        let navController = UINavigationController(rootViewController: viewController)
        
        if let sheetPresentationController = navController.sheetPresentationController {
            
            sheetPresentationController.detents = [.medium()]
            
        }
        
        present(navController, animated: true)
        
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
        
        let longPressRecognizer = UILongPressGestureRecognizer(
            target: self, action: #selector(longPressed(sender:)))
        
        articleDetailTableView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.articleDetailTableView)
            
            if let indexPath = articleDetailTableView.indexPathForRow(at: touchPoint) {
                
                // 彈跳出 User 視窗
                
                guard let viewController = UIStoryboard
                    .chat
                    .instantiateViewController(
                    withIdentifier: String(describing: UserInfoViewController.self)
                    ) as? UserInfoViewController else { return }
                
                viewController.deleteAccount = false
                
                if indexPath.section == 1 {
                    
                    viewController.selectUserID = articleMessages[indexPath.row].userID
                    
                    if usersInfo.filter({ $0.userID == articleMessages[indexPath.row].userID }).count == 0 {
                        
                        viewController.deleteAccount = true
                        
                    }
                    
                    self.view.addSubview(viewController.view)

                    self.addChild(viewController)
                    
                }
                
            }
            
        }
        
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
            
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ArticleMessageTableViewCell.self),
                for: indexPath
            )
            
            guard let cell = cell as? ArticleMessageTableViewCell else { return cell }
            
            let userInfo = usersInfo.filter({ $0.userID == articleMessages[indexPath.row].userID })
            
            var userName = String()
            
            var isBlock = false
            
            if userInfo.count != 0 {
                
                userName = userInfo[0].userName
                
                if blockadeList.filter({ $0 == userInfo[0].userID }).count != 0 {
                    
                    isBlock = true
                    
                }
                
            } else {
                
                userName = "[帳號已刪除]"

            }
            
            cell.showMessages(
                articleMessage: articleMessages[indexPath.row],
                articleUserID: forumArticle?.userID ?? "",
                userName: userName,
                isBlock: isBlock
            )
            
            cell.selectionStyle = .none
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let forumArticle = forumArticle else { return }
        
        if indexPath.section == 0 && forumArticle.content[indexPath.row].contentType == SendType.image.title {
            
            myImageView.loadImage(forumArticle.content[indexPath.row].contentText)
            
            showPhoto()
            
        } else if indexPath.section == 1 && articleMessages[indexPath.row].message.contentType == SendType.image.title {
            
            myImageView.loadImage(articleMessages[indexPath.row].message.contentText)
            
            showPhoto()
            
        }
        
    }
    
    func showPhoto() {
        
        // 展示 image (pop-up Image 單獨顯示的視窗)
        let browser = JXPhotoBrowser()

        browser.numberOfItems = { 1 }

        browser.reloadCellAtIndex = { context in

            let browserCell = context.cell as? JXPhotoBrowserImageCell
            
            browserCell?.imageView.image = self.myImageView.image
            
        }

        browser.show()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: ArticleDetailHeaderView.self))

            guard let headerView = headerView as? ArticleDetailHeaderView else { return headerView }
            
            guard let forumArticle = forumArticle else { return headerView }
            
            let userInfo = usersInfo.filter({ $0.userID == forumArticle.userID })
            
            if userInfo.count != 0 {
             
                let userName = userInfo[0].userName

                headerView.showArticleDetail(forumArticle: forumArticle, userName: userName)
                
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            
            headerView.addGestureRecognizer(tapGestureRecognizer)
            
            return headerView
            
        } else {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: ArticleMessageHeaderView.self))

            guard let headerView = headerView as? ArticleMessageHeaderView else { return headerView }
            
            return headerView
        }
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {

        guard let viewController = UIStoryboard
            .chat
            .instantiateViewController(
            withIdentifier: String(describing: UserInfoViewController.self)
            ) as? UserInfoViewController else { return }
        
        viewController.deleteAccount = false
        
        viewController.selectUserID = forumArticle?.userID ?? ""
        
        self.view.addSubview(viewController.view)

        self.addChild(viewController)
        
    }
    
}
