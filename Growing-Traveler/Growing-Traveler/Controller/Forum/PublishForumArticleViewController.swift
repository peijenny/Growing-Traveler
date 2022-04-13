//
//  PublishForumArticleViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit

class PublishForumArticleViewController: UIViewController {

    @IBOutlet weak var publishArticleTableView: UITableView! {
        
        didSet {
            
            publishArticleTableView.delegate = self
            
            publishArticleTableView.dataSource = self
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishArticleTableView.register(
            UINib(nibName: String(describing: PublishArticleTypeTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: PublishArticleTypeTableViewCell.self)
        )
        
        publishArticleTableView.register(
            UINib(nibName: String(describing: PublishArticleContentTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: PublishArticleContentTableViewCell.self)
        )

    }

}

extension PublishForumArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PublishArticleTypeTableViewCell.self),
                for: indexPath
            )

            guard let cell = cell as? PublishArticleTypeTableViewCell else { return cell }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PublishArticleContentTableViewCell.self),
                for: indexPath
            )

            guard let cell = cell as? PublishArticleContentTableViewCell else { return cell }
            
            return cell
            
        }
        
    }
    


}
