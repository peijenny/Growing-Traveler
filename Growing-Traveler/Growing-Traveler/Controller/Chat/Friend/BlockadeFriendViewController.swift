//
//  BlockadeFriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit
import PKHUD

class BlockadeFriendViewController: UIViewController {
    
    var blockadeTableView = UITableView()
    
    var userManager = UserManager()
    
    var usersInfo: [UserInfo] = []
    
    var friendManager = FriendManager()
    
    var friend: Friend?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "封鎖列表"
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        setBackgroundView()
        
        setTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUsersInfoData()
        
        fetchBlockadeData()
        
    }
    
    func fetchUsersInfoData() {
        
        userManager.fetchUsersData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let usersInfo):
                
                strongSelf.usersInfo = usersInfo
                
                strongSelf.blockadeTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
    }
    
    func fetchBlockadeData() {
        
        friendManager.listenFriendListData(fetchUserID: userID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let friend):
                
                strongSelf.friend = friend
                
                strongSelf.blockadeTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func setBackgroundView() {
        
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightGary.hexText)
        
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
            blockadeTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -160.0)
        ])
        
        blockadeTableView.register(
            UINib(nibName: String(describing: FriendListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: FriendListTableViewCell.self)
        )

        blockadeTableView.delegate = self
        
        blockadeTableView.dataSource = self
        
    }

}

extension BlockadeFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friend?.blockadeList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FriendListTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? FriendListTableViewCell else { return cell }
        
        let userInfo = usersInfo.filter({ $0.userID == friend?.blockadeList[indexPath.row] })
        
        if userInfo.count != 0 {
            
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
            
            friendManager.updateData(friend: friend)
            
            HUD.flash(.labeledSuccess(title: "已解除封鎖此帳號", subtitle: nil), delay: 0.5)
            
        }
        
    }
    
}
