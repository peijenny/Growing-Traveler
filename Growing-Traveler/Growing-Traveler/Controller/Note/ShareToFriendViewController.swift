//
//  ShareToFriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/5.
//

import UIKit

class ShareToFriendViewController: UIViewController {
    
    // MARK: - IBOutlet / Components
    var shareToFriendTableView = UITableView()
    
    // MARK: - Property
    var chatRoomManager = ChatRoomManager()
    
    var friendManager = FriendManager()
    
    var userManager = UserManager()
    
    var usersInfo: [UserInfo] = []
    
    var chats: [Chat] = []
    
    var friendList: [String] = []
    
    var shareType: String?
    
    var shareID: String?
    
    var userName: String?
    
    var sendType = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "分享\(sendType)至好友聊天室"
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        setTableView()
        
        setNavigationItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listenFriendListData()
        
        fetchChatRoomData()
        
    }
    
    
    // MARK: - Set UI
    func setTableView() {
        
        shareToFriendTableView.backgroundColor = UIColor.clear
        
        shareToFriendTableView.separatorStyle = .none
        
        view.addSubview(shareToFriendTableView)
        
        shareToFriendTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shareToFriendTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            shareToFriendTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareToFriendTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shareToFriendTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -110.0)
        ])
        
        shareToFriendTableView.register(
            UINib(nibName: String(describing: FriendListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FriendListTableViewCell.self))

        shareToFriendTableView.delegate = self
        
        shareToFriendTableView.dataSource = self
        
    }
    
    func setNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(closeFriendListButton))

    }
    
    // MARK: - Method
    func listenFriendListData() {
        
        friendManager.listenFriendListData(fetchUserID: KeyToken().userID) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let friend):
                
                self.friendList = friend.friendList
                
                self.fetchUserInfoData()
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    func fetchChatRoomData() {

        chatRoomManager.fetchFriendsChatData { [weak self] result in

            guard let self = self else { return }

            switch result {

            case .success(let chats):

                self.chats = chats
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }

        }

    }
    
    func fetchUserInfoData() {
        
        userManager.fetchUsersInfo { [weak self] result in
            
            guard let self = self else { return }

            switch result {

            case .success(let usersInfo):
                
                self.userName = usersInfo.filter({ $0.userID == KeyToken().userID })[0].userName
                
                let usersInfo = usersInfo
                
                for index in 0..<self.friendList.count {
                    
                    let filterUserInfo = usersInfo.filter({ $0.userID == self.friendList[index] })
                    
                    if filterUserInfo.count != 0 {
                        
                        self.usersInfo.append(filterUserInfo[0])
                    }
                    
                }
                
                self.shareToFriendTableView.reloadData()

            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
    }
    
    // MARK: - Target / IBAction
    @objc func closeFriendListButton(sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

// MARK: - TableView delegate / dataSource
extension ShareToFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FriendListTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? FriendListTableViewCell else { return cell }
        
        cell.showFriendListInfo(friendInfo: usersInfo[indexPath.row])
        
        cell.unblockButton.addTarget(self, action: #selector(shareToFriendButton), for: .touchUpInside)
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    @objc func shareToFriendButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: shareToFriendTableView)

        if let indexPath = shareToFriendTableView.indexPathForRow(at: point) {
            
            var selectChat = chats.filter({ $0.friendID == usersInfo[indexPath.row].userID })[0]
            
            let createTime = TimeInterval(Int(Date().timeIntervalSince1970))
            
            selectChat.messageContent.append(MessageContent(
                createTime: createTime, sendMessage: shareID ?? "",
                sendType: shareType ?? "", sendUserID: KeyToken().userID))
            
            chatRoomManager.addData(userName: userName ?? "", chat: selectChat)
            
            HandleResult.shareToFriendSuccess.messageHUD
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
