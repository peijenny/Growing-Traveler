//
//  FormViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit
import PKHUD

class ForumViewController: BaseViewController {

    @IBOutlet weak var articleTableView: UITableView! {
        
        didSet {
            
            articleTableView.delegate = self
            
            articleTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var forumArticleManager = ForumArticleManager()
    
    var friendManager = FriendManager()
    
    var userManager = UserManager()
    
    var forumArticles: [ForumArticle] = []
    
    var usersInfo: [UserInfo] = []
    
    var allForumArticles: [[ForumArticle]] = []
    
    var searchForumArticles: [ForumArticle] = [] {
        
        didSet {
            
            articleTableView.reloadData()
            
        }
        
    }
    
    var forumType: [ForumType] = [.essay, .question, .chat]
    
    var blockadeList: [String] = []
    
    var inputText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItem()
        
        registerTableViewCell()
        
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        HUD.show(.labeledProgress(title: "文章載入中...", subtitle: nil))
        
        fetchFriendBlockadeListData()
        
        fetchUserInfoData()
        
        if userID == "" {
            
            listenForumArticleData()
            
            fetchSearchData()
            
        }
        
    }
    
    func registerTableViewCell() {
        
        articleTableView.register(
            UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ArticleTableViewCell.self))

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
            
            authViewController.modalPresentationStyle = .formSheet

            present(authViewController, animated: true, completion: nil)
            
            return
            
        }

        let viewController = PublishForumArticleViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func fetchFriendBlockadeListData() {
        
        friendManager.fetchFriendListData(fetchUserID: userID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let userFriend):
                
                strongSelf.blockadeList = userFriend.blockadeList
                
                strongSelf.listenForumArticleData()
                
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

    func listenForumArticleData() {
        
        forumArticleManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):

                var filterData = data
                
                for index in 0..<strongSelf.blockadeList.count {
                    
                    filterData = filterData.filter({ $0.userID != strongSelf.blockadeList[index] })
                    
                }
                
                var essay = filterData.filter({ $0.forumType == ForumType.essay.title })
                
                var question = filterData.filter({ $0.forumType == ForumType.question.title })
                
                var chat = filterData.filter({ $0.forumType == ForumType.chat.title })
                
                essay = (essay.count > 5) ? Array(essay[0..<5]) : essay
                
                question = (question.count > 5) ? Array(question[0..<5]) : question
                
                chat = (chat.count > 5) ? Array(chat[0..<5]) : chat
                
                strongSelf.allForumArticles = [essay, question, chat]
                
                strongSelf.articleTableView.reloadData()
                
                HUD.hide()
                
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
                
                for index in 0..<strongSelf.blockadeList.count {
                    
                    filterData = filterData.filter({ $0.userID != strongSelf.blockadeList[index] })
                    
                }
                
                strongSelf.forumArticles = filterData
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
}

extension ForumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return forumType.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inputText == nil && !allForumArticles.isEmpty {
            
            return allForumArticles[section].count
            
        } else {
            
            return searchForumArticles.filter({ $0.forumType == forumType[section].title }).count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let searchArticels = searchForumArticles.filter({ $0.forumType == forumType[indexPath.section].title })

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? ArticleTableViewCell else { return cell }
        
        var isLastOne = false
        
        var amountOver = forumArticles.filter({ $0.forumType == forumType[indexPath.section].title }).count > 5
        
        if inputText == nil {
            
            let userInfo = usersInfo.filter({ $0.userID == allForumArticles[indexPath.section][indexPath.row].userID })
            
            if !userInfo.isEmpty {
                
                let userName = userInfo[0].userName
                
                cell.showForumArticle(
                    forumArticle: allForumArticles[indexPath.section][indexPath.row], userName: userName)
                
            }
            
            isLastOne = allForumArticles[indexPath.section].count - 1 == indexPath.row
            
        } else {
            
            amountOver = searchArticels.count > 5
            
            isLastOne = false

            let userInfo = usersInfo.filter({ $0.userID == searchArticels[indexPath.row].userID })

            if !userInfo.isEmpty {

                cell.showForumArticle(forumArticle: searchArticels[indexPath.row], userName: userInfo[0].userName)

            }
            
        }
        
        cell.showLoadMoreButton(amountOver: amountOver, isLastOne: isLastOne)
        
        cell.loadMoreButton.addTarget(self, action: #selector(loadMoreButton), for: .touchUpInside)
        
        cell.userInfoButton.addTarget(self, action: #selector(showUserInfoButton), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func showUserInfoButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: articleTableView)

        if let indexPath = articleTableView.indexPathForRow(at: point) {
            
            guard let viewController = UIStoryboard.chat.instantiateViewController(
                withIdentifier: String(describing: UserInfoViewController.self)
            ) as? UserInfoViewController else { return }
            
            viewController.deleteAccount = false
            
            if inputText != nil {
                
                let selectForumType = forumType[indexPath.section].title
                
                let searchArticle = searchForumArticles.filter({ $0.forumType == selectForumType })
                
                viewController.selectUserID = searchArticle[indexPath.row].userID
                
                viewController.articleID = searchArticle[indexPath.row].id
                
            } else {
                
                viewController.selectUserID = allForumArticles[indexPath.section][indexPath.row].userID
                
                viewController.articleID = allForumArticles[indexPath.section][indexPath.row].id
                
            }
            
            viewController.reportContentType = ReportContentType.article.title
            
            viewController.blockContentType = BlockContentType.article.title
            
            viewController.getFriendStatus = { [weak self] isBlock in
                
                guard let strongSelf = self else { return }
                
                if isBlock {
                    
                    strongSelf.fetchFriendBlockadeListData()
                    
                    strongSelf.fetchUserInfoData()
                    
                }
                
            }
            
            self.view.addSubview(viewController.view)

            self.addChild(viewController)
            
        }
        
    }
    
    @objc func loadMoreButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: articleTableView)

        if let indexPath = articleTableView.indexPathForRow(at: point) {
            
            let viewController = MoreArticlesViewController()
            
            viewController.forumType = forumType[indexPath.section].title
            
            navigationController?.pushViewController(viewController, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let viewController = ArticleDetailViewController()
        
        let noSearchArticle = allForumArticles[indexPath.section][indexPath.row]
        
        let searchAllArticles = searchForumArticles.filter({ $0.forumType == forumType[indexPath.section].title })
        
        viewController.forumArticle = (inputText == nil) ? noSearchArticle : searchAllArticles[indexPath.row]

        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return forumType[section].title
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40.0
        
    }
    
}

extension ForumViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        inputText = (searchText == "") ? nil : searchText.lowercased()
        
        searchForumArticles = forumArticles.filter({ $0.title.lowercased().range(of: searchText.lowercased()) != nil })

    }
    
}
