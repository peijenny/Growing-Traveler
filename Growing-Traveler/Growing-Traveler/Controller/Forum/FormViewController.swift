//
//  FormViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit

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
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forumArticles.count 
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ArticleTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? ArticleTableViewCell else { return cell }
        
        cell.titleLabel.text = forumArticles[indexPath.row].title
        
        cell.categoryLabel.text = forumArticles[indexPath.row].category.title
        
        cell.userIDLabel.text = userID
        
        for index in 0..<forumArticles[indexPath.row].content.count {
            
            if forumArticles[indexPath.row].content[index].contentType == "image" {
                
                guard let imageURL = URL(string: forumArticles[indexPath.row].content[index].contentText) else {
                    
                    print("圖片連結錯誤！")
                    
                    return cell
                }
                
                cell.mainImageView.load(url: imageURL)
                
                return cell
            }
            
        }
        
        return cell
        
    }
    
}
