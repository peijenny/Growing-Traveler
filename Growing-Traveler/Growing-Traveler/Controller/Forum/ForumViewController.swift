//
//  FormViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit

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
    
    var forumArticleType: ForumArticleType?
    
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
        
//        fetchSearchData()
        
        fetchUserInfoData()
        
    }
    
    func setNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addForumArticle))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
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
                        
                        filterData = data.filter({ $0.userID != strongSelf.blockadeList[index] })
                        
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
                
                strongSelf.forumArticleType = ForumArticleType(essay: essay, question: question, chat: chat)
                
                strongSelf.articleTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
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
                        
                        filterData = data.filter({ $0.userID != strongSelf.blockadeList[index] })
                        
                    }
                    
                }
                
                strongSelf.forumArticles = filterData
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
}

extension ForumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return forumType.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inputText == nil {
            
            if section == 0 {
                
                return forumArticleType?.essay.count ?? 0
                
            } else if section == 1 {
                
                return forumArticleType?.question.count ?? 0
                
            } else {
                
                return forumArticleType?.chat.count ?? 0
                
            }
            
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
        
        guard let forumArticleType = forumArticleType else { return cell }
        
        var isLastOne = false
        
        var amountOver = forumArticles.filter({ $0.forumType == forumType[indexPath.section] }).count > 5
        
        if indexPath.section == 0 && inputText == nil {
            
            let userInfo = usersInfo.filter({ $0.userID == forumArticleType.essay[indexPath.row].userID })
            
            if userInfo.count != 0 {
                
                let userName = userInfo[0].userName
                
                cell.showForumArticle(
                    forumArticle: forumArticleType.essay[indexPath.row],
                    userName: userName
                )
                
            }
            
            isLastOne = forumArticleType.essay.count - 1 == indexPath.row
            
        } else if indexPath.section == 1 && inputText == nil {
            
            let userInfo = usersInfo.filter({ $0.userID == forumArticleType.question[indexPath.row].userID })
            
            if userInfo.count != 0 {
                
                let userName = userInfo[0].userName
                
                cell.showForumArticle(
                    forumArticle: forumArticleType.question[indexPath.row],
                    userName: userName
                )
                
            }
            
            isLastOne = forumArticleType.question.count - 1 == indexPath.row
            
        } else if indexPath.section == 2 && inputText == nil {
            
            let userInfo = usersInfo.filter({ $0.userID == forumArticleType.chat[indexPath.row].userID })
            
            if userInfo.count != 0 {
                
                let userName = userInfo[0].userName
                
                cell.showForumArticle(
                    forumArticle: forumArticleType.chat[indexPath.row],
                    userName: userName
                )
                
            }
            
            isLastOne = forumArticleType.chat.count - 1 == indexPath.row
            
        }
        
        if inputText != nil {
            
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
        
        if indexPath.section == 0 {
            
            viewController.forumArticle = forumArticleType?.essay[indexPath.row]
            
        } else if indexPath.section == 1 {
            
            viewController.forumArticle = forumArticleType?.question[indexPath.row]
            
        } else if indexPath.section == 2 {
            
            viewController.forumArticle = forumArticleType?.chat[indexPath.row]
            
        }

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
