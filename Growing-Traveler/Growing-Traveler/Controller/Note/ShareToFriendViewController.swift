//
//  ShareToFriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/5.
//

import UIKit
import PKHUD

class ShareToFriendViewController: UIViewController {
    
    var shareToFriendTableView = UITableView()

    var sendType = ""
    
    var friendManager = FriendManager()
    
    var friendList: [String] = []
    
    var chatRoomManager = ChatRoomManager()
    
    var chats: [Chat] = []
    
    var userManager = UserManager()
    
    var usersInfo: [UserInfo] = []
    
    var shareType: String?
    
    var shareID: String?
    
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "分享\(sendType)至好友聊天室"
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        setTableView()
        
        setNavigationItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listenFriendListData()
        
        fetchChatRoomData()
        
    }
    
    func listenFriendListData() {
        
        friendManager.listenFriendListData(fetchUserID: userID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let friend):
                
                strongSelf.friendList = friend.friendList
                
                strongSelf.fetchUserInfoData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func fetchChatRoomData() {

        chatRoomManager.fetchFriendsChatData { [weak self] result in

            guard let strongSelf = self else { return }

            switch result {

            case .success(let chats):

                strongSelf.chats = chats
                
                // fetch user 所有的聊天記錄
                
            case .failure(let error):

                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

            }

        }

    }
    
    func fetchUserInfoData() {
        
        userManager.fetchUsersData { [weak self] result in
            
            guard let strongSelf = self else { return }

            switch result {

            case .success(let usersInfo):
                
                strongSelf.userName = usersInfo.filter({ $0.userID == userID })[0].userName
                
                let usersInfo = usersInfo
                
                for index in 0..<strongSelf.friendList.count {
                    
                    let filterUserInfo = usersInfo.filter({ $0.userID == strongSelf.friendList[index] })
                    
                    if filterUserInfo.count != 0 {
                        
                        strongSelf.usersInfo.append(filterUserInfo[0])
                    }
                    
                }
                
                strongSelf.shareToFriendTableView.reloadData()

            case .failure(let error):

                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

            }
            
        }
    }
    
    func setTableView() {
        
        shareToFriendTableView.backgroundColor = UIColor.clear
        
        shareToFriendTableView.separatorStyle = .none
        
        view.addSubview(shareToFriendTableView)
        
        shareToFriendTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shareToFriendTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            shareToFriendTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareToFriendTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shareToFriendTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -160.0)
        ])
        
        shareToFriendTableView.register(
            UINib(nibName: String(describing: FriendListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FriendListTableViewCell.self)
        )

        shareToFriendTableView.delegate = self
        
        shareToFriendTableView.dataSource = self
        
    }
    
    func setNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(closeFriendListButton))

    }
    
    @objc func closeFriendListButton(sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension ShareToFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FriendListTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? FriendListTableViewCell else { return cell }
        
        cell.showFriendListInfo(friendInfo: usersInfo[indexPath.row])
        
        cell.unblockButton.addTarget(self, action: #selector(shareToFriendButton), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func shareToFriendButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: shareToFriendTableView)

        if let indexPath = shareToFriendTableView.indexPathForRow(at: point) {
            
            var selectChat = chats.filter({ $0.friendID == usersInfo[indexPath.row].userID })[0]
            
            selectChat.messageContent.append(MessageContent(
                createTime: TimeInterval(Int(Date().timeIntervalSince1970)),
                sendMessage: shareID ?? "",
                sendType: shareType ?? "",
                sendUserID: userID
            ))
            
            chatRoomManager.addData(userName: userName ?? "", chat: selectChat)
            
            HUD.flash(.labeledSuccess(title: "傳送成功", subtitle: nil), delay: 0.5)
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
