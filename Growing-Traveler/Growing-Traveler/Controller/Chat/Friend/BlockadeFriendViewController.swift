//
//  BlockadeFriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit

class BlockadeFriendViewController: UIViewController {
    
    // MARK: - IBOutlet / Components
    var blockadeTableView = UITableView()
    
    // MARK: - Property
    var friendManager = FriendManager()
    
    var userManager = UserManager()
    
    var usersInfo: [UserInfo] = []
    
    var friend: Friend?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "封鎖列表"
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        setBackgroundView()
        
        setTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUsersInfoData()
        
        fetchBlockadeData()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    // MARK: - Set UI
    func setBackgroundView() {
        
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
        view.addSubview(backgroundView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
    }
    
    func setTableView() {
        
        blockadeTableView.backgroundColor = UIColor.clear
        
        blockadeTableView.separatorStyle = .none
        
        view.addSubview(blockadeTableView)
        
        blockadeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blockadeTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            blockadeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            blockadeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            blockadeTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -110.0)
        ])
        
        blockadeTableView.register(
            UINib(nibName: String(describing: FriendListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FriendListTableViewCell.self))

        blockadeTableView.delegate = self
        
        blockadeTableView.dataSource = self
        
    }
    
    // MARK: - Method
    func fetchUsersInfoData() {
        
        userManager.fetchUsersInfo { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let usersInfo):
                
                self.usersInfo = usersInfo
                
                self.blockadeTableView.reloadData()
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
    }
    
    func fetchBlockadeData() {
        
        friendManager.listenFriendListData(fetchUserID: KeyToken().userID) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let friend):
                
                self.friend = friend
                
                self.blockadeTableView.reloadData()
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }

}

// MARK: - TableView delegate / dataSource
extension BlockadeFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friend?.blockadeList.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FriendListTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? FriendListTableViewCell else { return cell }
        
        let userInfo = usersInfo.filter({ $0.userID == friend?.blockadeList[indexPath.row] })
        
        if !userInfo.isEmpty {
            
            cell.showBlockadeUserInfo(friendInfo: userInfo[0])
            
        }
        
        cell.unblockButton.addTarget(self, action: #selector(unblockUserButton), for: .touchUpInside)
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    @objc func unblockUserButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: blockadeTableView)
        
        guard var friend = friend else { return }

        if let indexPath = blockadeTableView.indexPathForRow(at: point) {
            
            friend.blockadeList.remove(at: indexPath.row)
            
            friendManager.updateFriendList(friend: friend)
            
            HandleResult.isUnBlockUser.messageHUD
            
        }
        
    }
    
}
