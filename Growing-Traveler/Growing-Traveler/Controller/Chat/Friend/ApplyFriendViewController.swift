//
//  ApplyFriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit

class ApplyFriendViewController: UIViewController {
    
    @IBOutlet weak var applyTableView: UITableView! {
        
        didSet {
            
            applyTableView.delegate = self
            
            applyTableView.dataSource = self
            
        }
        
    }
    
    var applyList: [String] = [] {
        
        didSet {
            
            fetchFriendInfoData(friendList: applyList)
            
        }
        
    }
    
    var friendsInfo: [User] = [] {
        
        didSet {
            
            applyTableView.reloadData()
            
        }
        
    }
    
    var ownFriend: Friend?
    
    var otherFriend: Friend?
    
    var friendManager = FriendManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "好友邀請"

        applyTableView.register(
            UINib(nibName: String(describing: FriendListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FriendListTableViewCell.self)
        )
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
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
    
    func fetchData(friendID: String) {
        
        friendManager.fetchFriendListData(fetchUserID: friendID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let friend):
                
                strongSelf.otherFriend = friend

                strongSelf.popupConfirmApplyPage()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func popupConfirmApplyPage() {
        
        guard let viewController = UIStoryboard
            .chat
            .instantiateViewController(
                withIdentifier: String(describing: ConfirmApplyViewController.self)
                ) as? ConfirmApplyViewController else {

                    return

                }
        
        guard let ownFriend = ownFriend else { return }
        
        guard let otherFriend = otherFriend else { return }

        viewController.bothSides = BothSides(owner: ownFriend, other: otherFriend)

        self.view.addSubview(viewController.view)

        self.addChild(viewController)
        
    }

}

extension ApplyFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        fetchData(friendID: applyList[indexPath.row])
        
    }
    
}
