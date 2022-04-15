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

class FormViewController: UIViewController {

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
        
        fetchData()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addArticleButton.imageView?.contentMode = .scaleAspectFill

        addArticleButton.layer.cornerRadius = addArticleButton.frame.width / 2
        
    }
    
    @IBAction func addArticleButton(_ sender: UIButton) {
        
        let viewController = UIStoryboard(
            name: "Forum",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: String(describing: PublishForumArticleViewController.self)
        )
        
        guard let viewController = viewController as? PublishForumArticleViewController else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func fetchData() {
        
        forumArticleManager.listenData(completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.forumArticles = data
                
                print("TEST \(strongSelf.forumArticles)")
                
            case .failure(let error):
                
                print(error)
                
            }
            
        })
        
    }
    
}

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return forumType.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let articles = forumArticles.filter({ $0.forumType == forumType[section] })
        
        return articles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let articles = forumArticles.filter({ $0.forumType == forumType[indexPath.section] })
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ArticleTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? ArticleTableViewCell else { return cell }
        
        cell.checkImage(forumArticle: articles[indexPath.row])

        cell.titleLabel.text = articles[indexPath.row].title
        
        cell.forumTypeLabel.text = articles[indexPath.row].forumType

        cell.categoryLabel.text = articles[indexPath.row].category.title

        cell.userIDLabel.text = userID
        
        cell.showLoadMoreButton(indexPathCount: indexPath.count - 1, indexPathRow: indexPath.row)
        
        cell.loadMoreButton.addTarget(self, action: #selector(loadMoreButton), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func loadMoreButton(sender: UIButton) {
        
        let viewController = UIStoryboard(
            name: "Forum",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: String(describing: MoreArticlesViewController.self)
        )
        
        guard let viewController = viewController as? MoreArticlesViewController else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        tableView.backgroundColor = UIColor.lightGray
        
        return forumType[section]
        
    }
    
}
