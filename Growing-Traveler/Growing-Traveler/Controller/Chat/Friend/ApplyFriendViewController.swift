//
//  ApplyFriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit

class ApplyFriendViewController: BaseViewController {
    
    // MARK: - IBOutlet / Components
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
    
    @IBOutlet weak var applyFriendBackgroundView: UIView!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    // MARK: - Property
    var friendManager = FriendManager()
    
    var ownFriend: Friend? {
        
        didSet {
            
            if let applyList = ownFriend?.applyList {
                
                fetchFriendInfoData(friendList: applyList)
                
            }
            
        }
    }
    
    var otherFriend: Friend?
    
    var searchUser: UserInfo?
    
    var allUsers: [UserInfo] = []
    
    var friendsInfo: [UserInfo] = [] {
        
        didSet {
            
            applyTableView.reloadData()
            
        }
        
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "好友邀請"
        
        fetchUserData()

        applyTableView.register(
            UINib(nibName: String(describing: FriendListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FriendListTableViewCell.self))
        
        inputEmailTextField.delegate = self
        
        userInfoView.isHidden = true
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        applyFriendBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
        userInfoView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        userInfoView.cornerRadius = 10
        
        addFriendButton.tintColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
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
                
            guard let self = self else { return }
            
            switch result {
                
            case .success(let friendsInfo):
                
                if friendsInfo.count == friendList.count {
                    
                    self.friendsInfo = friendsInfo
                    
                }
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    func fetchFriendListData(friendID: String) {
        
        friendManager.fetchFriendListData(fetchUserID: friendID) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let friend):
                
                if friendID == KeyToken().userID {
                    
                    self.ownFriend = friend
                    
                } else {
                    
                    self.otherFriend = friend

                    if friendID != self.searchUser?.userID {
                        
                        self.popupConfirmApplyPage()
                        
                    }
                    
                    if !friend.blockadeList.filter({ $0 == KeyToken().userID }).isEmpty {
                        
                        self.hintTextLabel.text = SearchFriendStatus.noSearch.title
                        
                    }
                    
                }
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    func fetchUserData() {
        
        friendManager.listenFriendInfoData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let users):
                
                self.allUsers = users
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
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

            guard let self = self else { return }
            
            guard let otherFriend = self.otherFriend else { return }

            if isConfirm {
                
                for index in 0..<self.friendsInfo.count {

                    if self.friendsInfo[index].userID == otherFriend.userID {

                        self.friendsInfo.remove(at: index)
                        
                        break

                    }

                }
                
                self.applyTableView.reloadData()
                
                self.fetchFriendListData(friendID: KeyToken().userID)

            }

        }

        self.addChild(viewController)
        
    }
    
    func handleFriendStatus(searchUser: UserInfo?) {
        
        if let searchUser = searchUser, let ownFriend = ownFriend {
            
            if searchUser.userID == KeyToken().userID {
                
                hintTextLabel.text = SearchFriendStatus.yourself.title
                
            } else if !ownFriend.blockadeList.filter({ $0 == searchUser.userID }).isEmpty {
                
                hintTextLabel.text = SearchFriendStatus.blocked.title
                
            } else if !ownFriend.friendList.filter({ $0 == searchUser.userID }).isEmpty {
                
                hintTextLabel.text = SearchFriendStatus.friendship.title
                
            } else if !ownFriend.deliveryList.filter({ $0 == searchUser.userID }).isEmpty {
                
                hintTextLabel.text = SearchFriendStatus.invitaion.title
                
            } else if !ownFriend.applyList.filter({ $0 == searchUser.userID }).isEmpty {
                
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
    
    // MARK: - Target / IBAction
    @IBAction func searchUserButton(_ sender: UIButton) {
        
        guard let inputEmail = inputEmailTextField.text else { return }
        
        let filterUsers = allUsers.filter({ $0.userEmail.lowercased() == inputEmail.lowercased() })
        
        if !filterUsers.isEmpty {
            
            userInfoView.isHidden = true
            
            searchUser = filterUsers[0]

            fetchFriendListData(friendID: filterUsers[0].userID)
            
            handleFriendStatus(searchUser: filterUsers[0])

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

// MARK: - TableView delegate / dataSource
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
        
        fetchFriendListData(friendID: friendsInfo[indexPath.row].userID)
        
    }
    
}
