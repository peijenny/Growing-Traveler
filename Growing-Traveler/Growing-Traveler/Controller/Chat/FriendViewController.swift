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
    
    var friend: Friend?
    
    var friendsInfo: [User] = [] {
        
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
        
        friendManager.fetchFriendListData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let friend):
                
                strongSelf.friend = friend
                
                strongSelf.fetchFriendInfoData(friendList: friend.friendList)
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func fetchFriendInfoData(friendList: [String]) {
        
        friendManager.fetchFriendInfoData(
            friendList: friendList,
            completion: { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                switch result {
                    
                case .success(let friendsInfo):
                    
                    if friendsInfo.count == friendList.count {
                        
                        strongSelf.friendsInfo = friendsInfo
                        
                    }
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
            
        })
    }
    
}

extension FriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsInfo.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FriendListTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? FriendListTableViewCell else { return cell }
        
        cell.showFriendInfo(friendName: friendsInfo[indexPath.row].userName)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = UIStoryboard(name: "Chat", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: ChatViewController.self))
        
        guard let viewController = viewController as? ChatViewController else { return }
        
        viewController.friendID = friendsInfo[indexPath.row].userID
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
