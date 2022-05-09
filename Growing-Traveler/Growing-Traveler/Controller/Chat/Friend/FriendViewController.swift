//
//  FriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/18.
//

import UIKit
import Charts
import PKHUD

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
            
            let longPressRecognizer = UILongPressGestureRecognizer(
                target: self, action: #selector(longPressed(sender:)))
            
            friendListTableView.addGestureRecognizer(longPressRecognizer)
            
        }
        
    }
    
    var friendManager = FriendManager()
    
    var ownerfriend: Friend?
    
    var friendsChat: [Chat] = [] {
        
        didSet {
            
            friendListTableView.reloadData()
            
        }
        
    }
    
    var chatRoomManager = ChatRoomManager()
    
    @IBOutlet weak var friendBackgroundView: UIView!
    
    var userManager = UserManager()
    
    var usersInfo: [UserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()

        friendListTableView.register(
            UINib(nibName: String(describing: FriendListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FriendListTableViewCell.self)
        )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listenFriendListData()
        
        fetchFriendsChatData()
        
        fetchUserInfo()
        
    }
    
    func fetchUserInfo() {
        
        userManager.fetchUsersData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let usersInfo):
                
                strongSelf.usersInfo = usersInfo
                
                strongSelf.friendListTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func listenFriendListData() {

        friendManager.listenFriendListData(fetchUserID: userID) { [weak self] result in

            guard let strongSelf = self else { return }

            switch result {

            case .success(let friend):

                strongSelf.ownerfriend = friend
                
                strongSelf.friendListTableView.reloadData()

            case .failure(let error):

                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

            }

        }

    }
    
    func fetchFriendsChatData() {
        
        chatRoomManager.fetchFriendsChatData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let friendsChat):
                
                strongSelf.friendsChat = friendsChat
                
                if friendsChat.count == 0 {
                    
                    strongSelf.friendBackgroundView.isHidden = false
                    
                } else {
                    
                    strongSelf.friendBackgroundView.isHidden = true
                    
                }
                
                strongSelf.friendListTableView.reloadData()

            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
        }
    }
    
    func setNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.add), style: .plain, target: self, action: #selector(applyFriendButton))

    }
    
    @objc func applyFriendButton(sender: UIButton) {
        
        let viewController = UIStoryboard(name: "Chat", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: ApplyFriendViewController.self))
        
        guard let viewController = viewController as? ApplyFriendViewController else { return }
        
        if let friend = ownerfriend {

            viewController.ownFriend = friend
            
        }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension FriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return friendsChat.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FriendListTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? FriendListTableViewCell else { return cell }

        let userInfo = usersInfo.filter({ $0.userID == friendsChat[indexPath.row].friendID })
        
        if userInfo.count != 0 {
            
            cell.showFriendInfo(
                friendInfo: userInfo[0],
                blockadeList: ownerfriend?.blockadeList ?? [],
                deleteAccount: false)
            
        } else {
            
            let blockUserInfo = UserInfo(
                userID: friendsChat[indexPath.row].friendID,
                userName: friendsChat[indexPath.row].friendName,
                userEmail: "", userPhoto: "", userPhone: "", signInType: "",
                achievement: Achievement(experienceValue: 0, completionGoals: [], loginDates: []),
                certification: [])
            
            cell.showFriendInfo(
                friendInfo: blockUserInfo,
                blockadeList: ownerfriend?.blockadeList ?? [],
                deleteAccount: true)
            
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.friendListTableView)
            
            if let indexPath = friendListTableView.indexPathForRow(at: touchPoint) {
                
                // 彈跳出 User 視窗
                
                guard let viewController = UIStoryboard
                    .chat
                    .instantiateViewController(
                    withIdentifier: String(describing: UserInfoViewController.self)
                    ) as? UserInfoViewController else { return }
                
                viewController.selectUserID = friendsChat[indexPath.row].friendID

                if usersInfo.filter({ $0.userID == friendsChat[indexPath.row].friendID }).count == 0 {
                    
                    viewController.deleteAccount = true
                    
                } else {
                    
                    viewController.deleteAccount = false
                    
                }
                
                self.view.addSubview(viewController.view)

                self.addChild(viewController)
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = UIStoryboard(name: "Chat", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: ChatViewController.self))
        
        guard let viewController = viewController as? ChatViewController else { return }
        
        viewController.friendID = friendsChat[indexPath.row].friendID
        
        viewController.userName = ownerfriend?.userName ?? ""
        
        if ownerfriend?.blockadeList.filter({ $0 == friendsChat[indexPath.row].friendID }).count == 0 {
            
            viewController.isBlock = false
            
        } else {
            
            viewController.isBlock = true
            
        }
        
        let userInfo = usersInfo.filter({ $0.userID == friendsChat[indexPath.row].friendID })
        
        if userInfo.count == 0 {
            
            viewController.deleteAccount = true
            
        } else {
            
            viewController.deleteAccount = false
            
        }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
