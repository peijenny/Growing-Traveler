//
//  FriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/18.
//

import UIKit

enum FriendType {
    
    case friend
    
    case blockade
    
    case apply
    
    var title: String {
        
        switch self {
            
        case .friend: return "好友列表"
            
        case .blockade: return "封鎖列表"
            
        case .apply: return "發出邀請列表"
            
        }
        
    }
    
}

class FriendViewController: UIViewController {

    @IBOutlet weak var friendListTableView: UITableView! {
        
        didSet {
            
            friendListTableView.delegate = self
            
            friendListTableView.dataSource = self
            
        }
        
    }
    
    var friendManager = FriendManager()
    
    var friend: Friend? {
        
        didSet {
            
            friendListTableView.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        friendListTableView.register(
            UINib(nibName: String(describing: FriendListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FriendListTableViewCell.self)
        )
        
        fetchFriendListData()
        
    }
    
    func fetchFriendListData() {
        
        friendManager.fetchData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let friend):
                
                strongSelf.friend = friend
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
}

extension FriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friend?.friendList.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FriendListTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? FriendListTableViewCell else { return cell }
        
        return cell
        
    }
    
}
