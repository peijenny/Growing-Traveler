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
    
}

class ForumViewController: BaseViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var addArticleButton: UIButton!
    
    @IBOutlet weak var articleTableView: UITableView! {
        
        didSet {
            
            articleTableView.delegate = self
            
            articleTableView.dataSource = self
            
        }
        
    }
    
    var forumArticleManager = ForumArticleManager()
    
    var forumArticles: [ForumArticle] = [] {
        
        didSet {
            
            articleTableView.reloadData()
            
        }
        
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        articleTableView.register(
            UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ArticleTableViewCell.self)
        )

        searchTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        
        fetchSearchData()
        
        searchTextField.text = nil
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addArticleButton.imageView?.contentMode = .scaleAspectFill

        addArticleButton.layer.cornerRadius = addArticleButton.frame.width / 2
        
    }
    
    @IBAction func addArticleButton(_ sender: UIButton) {
        
        guard userID != "" else {

            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {

                authVC.modalPresentationStyle = .overCurrentContext

                present(authVC, animated: false, completion: nil)
            }

            return
        }

        let viewController = PublishForumArticleViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func fetchData() {
        
        forumArticleManager.listenData(completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.forumArticles = data
                
            case .failure(let error):
                
                print(error)
                
            }
            
        })
        
    }
    
    func fetchSearchData() {
        
        forumArticleManager.fetchSearchData(completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.searchForumArticles = data
                
            case .failure(let error):
                
                print(error)
                
            }
            
        })
        
    }
    
    @IBAction func searchArticleButton(_ sender: UIButton) {
        
        guard let inputText = searchTextField.text else { return }

        forumArticles = searchForumArticles.filter({ $0.title.range(of: inputText) != nil })
        
        if inputText == "" {
            
            fetchData()
            
        }
        
    }
    
}

extension ForumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return forumType.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let articles = forumArticles.filter({ $0.forumType == forumType[section] })
        
        return articles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let articles = forumArticles.filter({ $0.forumType == forumType[indexPath.section] })
        
        let searchArticels = searchForumArticles.filter({ $0.forumType == forumType[indexPath.section] })

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ArticleTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? ArticleTableViewCell else { return cell }
        
        cell.showForumArticle(forumArticle: articles[indexPath.row])
        
        let amountOver: Bool = (searchArticels.count > articles.count)
        
        let isSearch: Bool = (searchTextField.text != "")
        
        let isLastOne: Bool = (articles.count - 1 == indexPath.row)
        
        cell.showLoadMoreButton(
            amountOver: amountOver, isSearch: isSearch, isLastOne: isLastOne)
        
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
        
        let articles = forumArticles.filter({ $0.forumType == forumType[indexPath.section] })

        let viewController = ArticleDetailViewController()
        
        viewController.forumArticle = articles[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return forumType[section]
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40.0
        
    }
    
}
