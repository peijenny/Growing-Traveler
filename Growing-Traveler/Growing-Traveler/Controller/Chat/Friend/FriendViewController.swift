//
//  FriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/18.
//

import UIKit
import Charts

class FriendViewController: UIViewController {

    // MARK: - IBOutlet / Components
    @IBOutlet weak var friendListTableView: UITableView! {
        
        didSet {
            
            friendListTableView.delegate = self
            
            friendListTableView.dataSource = self
            
            let longPressRecognizer = UILongPressGestureRecognizer(
                target: self, action: #selector(longPressed(sender:)))
            
            friendListTableView.addGestureRecognizer(longPressRecognizer)
            
        }
        
    }
    
    @IBOutlet weak var friendBackgroundView: UIView!
    
    @IBOutlet weak var headerView: UIView!
    
    let badgeLabel = UILabel()
    
    // MARK: - Property
    var chatRoomManager = ChatRoomManager()
    
    var friendManager = FriendManager()
    
    var userManager = UserManager()
    
    var ownerfriend: Friend?
    
    var usersInfo: [UserInfo] = []
    
    var friendsChat: [Chat] = [] {
        
        didSet {
            
            friendListTableView.reloadData()
            
        }
        
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()

        registerTableViewCell()
        
        headerView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listenFriendListData()
        
        fetchFriendsChatData()
        
        fetchUserInfoData()
        
    }
    
    // MARK: - Set UI
    func setNavigationItems() {
        
        // badge label
        badgeLabel.frame = CGRect(x: 20, y: -5, width: 20, height: 20)
        
        badgeLabel.layer.borderColor = UIColor.clear.cgColor
        
        badgeLabel.layer.borderWidth = 2
        
        badgeLabel.layer.cornerRadius = badgeLabel.bounds.size.height / 2
        
        badgeLabel.textAlignment = .center
        
        badgeLabel.layer.masksToBounds = true
        
        badgeLabel.font = UIFont(name: "PingFang TC", size: 12)
        
        badgeLabel.textColor = UIColor.white
        
        badgeLabel.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightRed.hexText)
        
        // rightBar button
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
        
        rightBarButton.setBackgroundImage(UIImage.asset(.add), for: .normal)
        
        rightBarButton.addTarget(self, action: #selector(applyFriendButton), for: .touchUpInside)
        
        if badgeLabel.text != nil {
            
            rightBarButton.addSubview(badgeLabel)
            
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
    }
    
    func registerTableViewCell() {
        
        friendListTableView.register(
            UINib(nibName: String(describing: FriendListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FriendListTableViewCell.self))
        
    }
    
    // MARK: - Method
    func fetchUserInfoData() {
        
        userManager.fetchUsersInfo { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let usersInfo):
                
                self.usersInfo = usersInfo
                
                self.friendListTableView.reloadData()
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    func listenFriendListData() {

        friendManager.listenFriendListData(fetchUserID: KeyToken().userID) { [weak self] result in

            guard let self = self else { return }

            switch result {

            case .success(let friend):

                self.ownerfriend = friend
                
                self.badgeLabel.text = (!friend.applyList.isEmpty) ? "\(friend.applyList.count)" : nil
                
                self.setNavigationItems()
                
                self.friendListTableView.reloadData()

            case .failure:
                
                HandleResult.readDataFailed.messageHUD

            }

        }

    }
    
    func fetchFriendsChatData() {
        
        chatRoomManager.fetchFriendsChatData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let friendsChat):
                
                self.friendsChat = friendsChat
                
                self.friendBackgroundView.isHidden = (friendsChat.count == 0) ? false : true
                
                self.friendListTableView.reloadData()

            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    // MARK: - Target / IBAction
    @objc func applyFriendButton(sender: UIButton) {
        
        let viewController = UIStoryboard.chat.instantiateViewController(
            withIdentifier: String(describing: ApplyFriendViewController.self))
        
        guard let viewController = viewController as? ApplyFriendViewController else { return }
        
        if let friend = ownerfriend {

            viewController.ownFriend = friend
            
        }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

// MARK: - TableView delegate / dataSource
extension FriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return friendsChat.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FriendListTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? FriendListTableViewCell else { return cell }

        let userInfo = usersInfo.filter({ $0.userID == friendsChat[indexPath.row].friendID })
        
        if userInfo.count != 0 {
            
            cell.showFriendInfo(
                friendInfo: userInfo[0], blockadeList: ownerfriend?.blockadeList ?? [], deleteAccount: false)
            
        } else {
            
            let blockUserInfo = UserInfo(
                userID: friendsChat[indexPath.row].friendID,
                userName: friendsChat[indexPath.row].friendName,
                userEmail: "", userPhoto: "", userPhone: "", signInType: "",
                achievement: Achievement(experienceValue: 0, completionGoals: [], loginDates: []),
                certification: [])
            
            cell.showFriendInfo(
                friendInfo: blockUserInfo, blockadeList: ownerfriend?.blockadeList ?? [], deleteAccount: true)
            
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.friendListTableView)
            
            if let indexPath = friendListTableView.indexPathForRow(at: touchPoint) {
                
                guard let viewController = UIStoryboard.chat.instantiateViewController(
                    withIdentifier: String(describing: UserInfoViewController.self)
                ) as? UserInfoViewController else { return }
                
                viewController.selectUserID = friendsChat[indexPath.row].friendID
                
                viewController.blockContentType = BlockContentType.user.title
                
                let isFilterUserInfo = usersInfo.filter({ $0.userID == friendsChat[indexPath.row].friendID }).isEmpty
                
                viewController.deleteAccount = (isFilterUserInfo) ? true : false

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
            
            let isFilterUserInfo = usersInfo.filter({ $0.userID == friendsChat[indexPath.row].friendID }).isEmpty
            
            viewController.deleteAccount = (isFilterUserInfo) ? true : false
            
            navigationController?.pushViewController(viewController, animated: true)
            
        } else {
            
            viewController.isBlock = true
            
        }
        
    }
    
}
