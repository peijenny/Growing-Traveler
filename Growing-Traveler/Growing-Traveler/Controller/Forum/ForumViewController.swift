//
//  FormViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit
import PKHUD

enum ForumType {
    
    case essay
    
    case question
    
    case chat
    
    var title: String {
        
        switch self {
            
        case .essay: return "文章"
            
        case .question: return "問題"
            
        case .chat: return "閒聊"
            
        }
        
    }
    
    var word: String {
        
        switch self {
            
        case .essay: return "essay"
            
        case .question: return "question"
            
        case .chat: return "chat"
            
        }
        
    }
    
}

class ForumViewController: BaseViewController {

    @IBOutlet weak var articleTableView: UITableView! {
        
        didSet {
            
            articleTableView.delegate = self
            
            articleTableView.dataSource = self
            
            let longPressRecognizer = UILongPressGestureRecognizer(
                target: self, action: #selector(longPressed(sender:)))
            
            articleTableView.addGestureRecognizer(longPressRecognizer)
            
        }
        
    }
    
    var forumArticleManager = ForumArticleManager()
    
    var forumArticles: [ForumArticle] = []
    
    var searchForumArticles: [ForumArticle] = [] {
        
        didSet {
            
            articleTableView.reloadData()
            
        }
        
    }
    
    var forumType: [String] = [
        ForumType.essay.title,
        ForumType.question.title,
        ForumType.chat.title
    ]
    
    var userManager = UserManager()
    
    var usersInfo: [UserInfo] = []
    
    var allForumArticles: [[ForumArticle]] = []
    
    var friendManager = FriendManager()
    
    var blockadeList: [String] = []
    
    var inputText: String?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        articleTableView.register(
            UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ArticleTableViewCell.self)
        )

        setNavigationItem()
        
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFriendBlockadeListData()
        
        fetchUserInfoData()
        
        if userID == "" {
            
            fetchData()
            
            fetchSearchData()
            
        }
        
    }
    
    func setNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.create), style: .plain, target: self, action: #selector(addForumArticle))

    }
    
    @objc func addForumArticle(sender: UIButton) {
        
        guard userID != "" else {

            guard let authViewController = UIStoryboard.auth.instantiateViewController(
                    withIdentifier: String(describing: AuthenticationViewController.self)
                    ) as? AuthenticationViewController else { return }
            
            authViewController.modalPresentationStyle = .popover

            present(authViewController, animated: true, completion: nil)
            
            return
        }

        let viewController = PublishForumArticleViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func fetchFriendBlockadeListData() {
        
        friendManager.fetchFriendListData(
        fetchUserID: userID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let userFriend):
                
                strongSelf.blockadeList = userFriend.blockadeList
                
                strongSelf.fetchData()
                
                strongSelf.fetchSearchData()
                
                strongSelf.articleTableView.reloadData()
                
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
                
                strongSelf.articleTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }

    func fetchData() {
        
        forumArticleManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):

                var filterData = data
                
                if strongSelf.blockadeList != [] {
                    
                    for index in 0..<strongSelf.blockadeList.count {
                        
                        filterData = filterData.filter({ $0.userID != strongSelf.blockadeList[index] })
                        
                    }
                    
                }
                
                var essay = filterData.filter({ $0.forumType == ForumType.essay.title })
                
                var question = filterData.filter({ $0.forumType == ForumType.question.title })
                
                var chat = filterData.filter({ $0.forumType == ForumType.chat.title })
                
                if essay.count > 5 {
                    
                    essay = Array(essay[0..<5])
                    
                }
                
                if question.count > 5 {
                    
                    question = Array(question[0..<5])
                    
                }
                
                if chat.count > 5 {
                    
                    chat = Array(chat[0..<5])
                    
                }
                
                strongSelf.allForumArticles = [essay, question, chat]
                
                strongSelf.articleTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
//                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func fetchSearchData() {
        
        forumArticleManager.fetchSearchData { [weak self] result in
            
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
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.articleTableView)
            
            if let indexPath = articleTableView.indexPathForRow(at: touchPoint) {
                
                // 彈跳出 User 視窗
                guard let viewController = UIStoryboard
                    .chat
                    .instantiateViewController(
                    withIdentifier: String(describing: UserInfoViewController.self)
                    ) as? UserInfoViewController else { return }
                
                viewController.deleteAccount = false
                
                if inputText != nil {
                    
                    let searchArticle = searchForumArticles.filter({ $0.forumType == forumType[indexPath.section] })
                    
                    viewController.selectUserID = searchArticle[indexPath.row].userID
                    
                } else {
                    
                    viewController.selectUserID = allForumArticles[indexPath.section][indexPath.row].userID
                    
                }
                
                self.view.addSubview(viewController.view)

                self.addChild(viewController)
                
            }
            
        }
        
    }
    
}

extension ForumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return forumType.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inputText == nil && allForumArticles.count != 0 {
            
            return allForumArticles[section].count
            
        } else if inputText == nil && allForumArticles.count != 0 {
            
            return 0
            
        } else {
            
            return searchForumArticles.filter({ $0.forumType == forumType[section] }).count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let searchArticels = searchForumArticles.filter({ $0.forumType == forumType[indexPath.section] })

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ArticleTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? ArticleTableViewCell else { return cell }
        
        var isLastOne = false
        
        var amountOver = forumArticles.filter({ $0.forumType == forumType[indexPath.section] }).count > 5
        
        if inputText == nil {
            
            let userInfo = usersInfo.filter({ $0.userID == allForumArticles[indexPath.section][indexPath.row].userID })
            
            if userInfo.count != 0 {
                
                let userName = userInfo[0].userName
                
                cell.showForumArticle(
                    forumArticle: allForumArticles[indexPath.section][indexPath.row],
                    userName: userName
                )
                
            }
            
            isLastOne = allForumArticles[indexPath.section].count - 1 == indexPath.row
            
        } else {
            
            amountOver = searchArticels.count > 5
            
            isLastOne = false

            let userInfo = usersInfo.filter({ $0.userID == searchArticels[indexPath.row].userID })

            if userInfo.count != 0 {

                let userName = userInfo[0].userName

                cell.showForumArticle(
                    forumArticle: searchArticels[indexPath.row],
                    userName: userName
                )

            }
            
        }
        
        cell.showLoadMoreButton(amountOver: amountOver, isLastOne: isLastOne)
        
        cell.loadMoreButton.addTarget(self, action: #selector(loadMoreButton), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func loadMoreButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: articleTableView)

        if let indexPath = articleTableView.indexPathForRow(at: point) {
            
            let viewController = MoreArticlesViewController()
            
            viewController.forumType = forumType[indexPath.section]
            
            navigationController?.pushViewController(viewController, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let viewController = ArticleDetailViewController()
        
        viewController.forumArticle = allForumArticles[indexPath.section][indexPath.row]

        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return forumType[section]
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40.0
        
    }
    
}

extension ForumViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            inputText = nil
            
        } else {
            
            inputText = searchText
            
        }
        
        searchForumArticles = forumArticles.filter({ $0.title.range(of: searchText) != nil })

    }
    
}
