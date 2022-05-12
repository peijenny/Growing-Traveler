//
//  ApplyFriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit
import PKHUD

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
    
    var friendManager = FriendManager()
    
    var otherFriend: Friend?
    
    var searchUser: UserInfo?
    
    var allUsers: [UserInfo] = []
    
    var friendsInfo: [UserInfo] = [] {
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "好友邀請"
        
        fetchUserData()

        applyTableView.register(
            UINib(nibName: String(describing: FriendListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FriendListTableViewCell.self))
        
        inputEmailTextField.delegate = self
        
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
        
        friendManager.fetchFriendInfoData(friendList: friendList) { [weak self] result in
                
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let friendsInfo):
                
                if friendsInfo.count == friendList.count {
                    
                    strongSelf.friendsInfo = friendsInfo
                    
                }
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
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
                    
                    if friend.blockadeList.filter({ $0 == userID }).isEmpty {
                        
                        strongSelf.hintTextLabel.text = SearchFriendStatus.noSearch.title
                        
                    }
                    
                }
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func popupConfirmApplyPage() {
        
        guard let viewController = UIStoryboard.chat.instantiateViewController(
            withIdentifier: String(describing: ConfirmApplyViewController.self)
        ) as? ConfirmApplyViewController else { return }
        
        guard let ownFriend = ownFriend else { return }
        
        guard let otherFriend = otherFriend else { return }

        viewController.bothSides = BothSides(owner: ownFriend, other: otherFriend)
        
        self.navigationController?.isNavigationBarHidden = true
        
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
        
        friendManager.listenFriendInfoData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let users):
                
                strongSelf.allUsers = users
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    @IBAction func searchUserButton(_ sender: UIButton) {
        
        guard let inputEmail = inputEmailTextField.text else { return }
        
        if allUsers.filter({ $0.userEmail.lowercased() == inputEmail.lowercased() }).isEmpty {
            
            userInfoView.isHidden = true
            
            searchUser = allUsers.filter({ $0.userEmail.lowercased() == inputEmail.lowercased() })[0]
            
            fetchData(friendID: searchUser?.userID ?? "")
            
            handleFriendStatus(searchUser: searchUser)
            
        } else {
            
            hintTextLabel.text = SearchFriendStatus.noSearch.title
            
        }
        
    }
    
    func handleFriendStatus(searchUser: UserInfo?) {
        
        if let searchUser = searchUser, let ownFriend = ownFriend {
            
            if searchUser.userID == userID {
                
                hintTextLabel.text = SearchFriendStatus.yourself.title
                
            } else if ownFriend.blockadeList.filter({ $0 == searchUser.userID }).isEmpty {
                
                hintTextLabel.text = SearchFriendStatus.blocked.title
                
            } else if ownFriend.friendList.filter({ $0 == searchUser.userID }).isEmpty {
                
                hintTextLabel.text = SearchFriendStatus.friendship.title
                
            } else if ownFriend.deliveryList.filter({ $0 == searchUser.userID }).isEmpty {
                
                hintTextLabel.text = SearchFriendStatus.invitaion.title
                
            } else if ownFriend.applyList.filter({ $0 == searchUser.userID }).isEmpty {
                
                hintTextLabel.text = SearchFriendStatus.applied.title
                
            } else {
                
                userInfoView.isHidden = false
                
                hintTextLabel.text = SearchFriendStatus.noRelation.title
                
                userInfoLabel.text = "\(searchUser.userName)（\(searchUser.userID)）"
                
            }
            
        } else {
            
            hintTextLabel.text = SearchFriendStatus.noSearch.title
            
        }
            
    }
    
    @IBAction func sendApplyButton(_ sender: UIButton) {

        if var ownFriend = ownFriend, var otherFriend = otherFriend {
            
            ownFriend.deliveryList.append(otherFriend.userID)
            
            otherFriend.applyList.append(ownFriend.userID)
            
            let bothSides = BothSides(owner: ownFriend, other: otherFriend)

            hintTextLabel.text = SearchFriendStatus.invitaion.title
            
            userInfoView.isHidden = true
            
            inputEmailTextField.text = nil
            
            searchUser = nil
            
            friendManager.addFriendData(bothSides: bothSides, confirmType: ConfirmType.apply.title)
            
        }
        
    }
    
}

extension ApplyFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsInfo.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FriendListTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? FriendListTableViewCell else { return cell }
        
        cell.showFriendInfo(
            friendInfo: friendsInfo[indexPath.row], blockadeList: ownFriend?.blockadeList ?? [], deleteAccount: false)
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        fetchData(friendID: friendsInfo[indexPath.row].userID)
        
    }
    
}
