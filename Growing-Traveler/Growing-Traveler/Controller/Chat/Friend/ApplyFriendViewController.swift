//
//  ApplyFriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit

enum SearchFriendStatus {
    
    case yourself
    
    case blocked
    
    case friendship
    
    case invitaion
    
    case applied
    
    case noSearch
    
    case noRelation
    
    var title: String {
        
        switch self {
            
        case .yourself: return "不可加入自己！"
            
        case .blocked: return "你已封鎖對方，如需申請為好友，請先解除封鎖！"
            
        case .friendship: return "你們已經是好友了！"
            
        case .invitaion: return "你已發送好友邀請，請等待對方同意！"
            
        case .applied: return "對方發出好友邀請給你！"
            
        case .noSearch: return "沒有該使用者的資料！請重新搜尋！"
            
        case .noRelation: return "你們還不是朋友，點擊按鈕發送好友邀請！"
            
        }
        
    }
    
}

class ApplyFriendViewController: BaseViewController {
    
    @IBOutlet weak var applyTableView: UITableView! {
        
        didSet {
            
            applyTableView.delegate = self
            
            applyTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var inputEmailTextField: UITextField!
    
    @IBOutlet weak var hintTextLabel: UILabel!
    
    @IBOutlet weak var userInfoLabel: UILabel!
    
    @IBOutlet weak var userInfoView: UIView!
    
    var friendsInfo: [User] = [] {
        
        didSet {
            
            applyTableView.reloadData()
            
        }
        
    }
    
    var ownFriend: Friend? {
        
        didSet {
            
            if let applyList = ownFriend?.applyList {
                
                fetchFriendInfoData(friendList: applyList)
                
            }
            
        }
    }
    
    var otherFriend: Friend?
    
    var allUsers: [User] = []
    
    var friendManager = FriendManager()
    
    var searchUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "好友邀請"

        applyTableView.register(
            UINib(nibName: String(describing: FriendListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FriendListTableViewCell.self)
        )
        
        inputEmailTextField.delegate = self
        
        fetchUserData()
        
        userInfoView.isHidden = true
        
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
                
                if friendID == userID {
                    
                    strongSelf.ownFriend = friend
                    
                } else {
                    
                    strongSelf.otherFriend = friend

                    if friendID != strongSelf.searchUser?.userID {
                        
                        strongSelf.popupConfirmApplyPage()
                        
                    }
                    
                }
                
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
        
        viewController.getConfirmStatus = { [weak self] isConfirm in

            guard let strongSelf = self else { return }
            
            guard let otherFriend = strongSelf.otherFriend else { return }

            if isConfirm {
                
                for index in 0..<strongSelf.friendsInfo.count {
                    
                    if strongSelf.friendsInfo[index].userID == otherFriend.userID {
                        
                        strongSelf.friendsInfo.remove(at: index)
                        
                    }
                }
                
                strongSelf.applyTableView.reloadData()
                
                strongSelf.fetchData(friendID: userID)

            }

        }

        self.addChild(viewController)
        
    }
    
    func fetchUserData() {
        
        friendManager.fetchFriendEmailData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let users):
                
                strongSelf.allUsers = users
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    @IBAction func searchUserButton(_ sender: UIButton) {
        
        guard let inputEmail = inputEmailTextField.text else { return }
        
        if allUsers.filter({ $0.userEmail == inputEmail }).count > 0 {
            
            userInfoView.isHidden = true
            
            searchUser = allUsers.filter({ $0.userEmail == inputEmail })[0]
            
            if let searchUser = searchUser, let ownFriend = ownFriend {
                
                fetchData(friendID: searchUser.userID)
                
                if searchUser.userID == userID {
                    
                    hintTextLabel.text = SearchFriendStatus.yourself.title
                    
                } else if ownFriend.blockadeList.filter({ $0 == searchUser.userID }).count > 0 {
                    
                    hintTextLabel.text = SearchFriendStatus.blocked.title
                    
                } else if ownFriend.friendList.filter({ $0 == searchUser.userID }).count > 0 {
                    
                    hintTextLabel.text = SearchFriendStatus.friendship.title
                    
                } else if ownFriend.deliveryList.filter({ $0 == searchUser.userID }).count > 0 {
                    
                    hintTextLabel.text = SearchFriendStatus.invitaion.title
                    
                } else if ownFriend.applyList.filter({ $0 == searchUser.userID }).count > 0 {
                    
                    hintTextLabel.text = SearchFriendStatus.applied.title
                    
                } else {
                    
                    userInfoView.isHidden = false
                    
                    hintTextLabel.text = SearchFriendStatus.noRelation.title

                    userInfoLabel.text = "\(searchUser.userName)（\(searchUser.userID)）"
                    
                }
                
            }
            
        } else {
            
            hintTextLabel.text = SearchFriendStatus.noSearch.title
        }
        
    }
    
    @IBAction func sendApplyButton(_ sender: UIButton) {
        
        // 發送好友邀請給對方
//        searchUser
        
        if var ownFriend = ownFriend, var otherFriend = otherFriend {
            
            ownFriend.deliveryList.append(otherFriend.userID)
            
            otherFriend.applyList.append(ownFriend.userID)
            
            let bothSides = BothSides(owner: ownFriend, other: otherFriend)
            
            print("TEST \(bothSides)")
            
            hintTextLabel.text = SearchFriendStatus.invitaion.title
            
            userInfoView.isHidden = true
            
            searchUser = nil
            
            inputEmailTextField.text = nil
            
            friendManager.addFriendData(bothSides: bothSides, confirmType: ConfirmType.apply.title)
            
        }
        
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
        
        fetchData(friendID: friendsInfo[indexPath.row].userID)
        
    }
    
}