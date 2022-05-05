//
//  RankViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/28.
//

import UIKit

class RankViewController: UIViewController {

    @IBOutlet weak var rankTableView: UITableView! {
        
        didSet {
            
            rankTableView.delegate = self
            
            rankTableView.dataSource = self
            
            let longPressRecognizer = UILongPressGestureRecognizer(
                target: self, action: #selector(longPressed(sender:)))
            
            rankTableView.addGestureRecognizer(longPressRecognizer)
            
        }
        
    }
    
    var friendManager = FriendManager()
    
    var usersInfo: [UserInfo] = []
    
    var blockadeList: [String] = []
    
    @IBOutlet weak var rankBackgroundView: UIView!
    
    @IBOutlet weak var rankCircleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "成長排行榜"
        
        listenUsersInfoData()
        
        rankTableView.register(
            UINib(nibName: String(describing: RankTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: RankTableViewCell.self)
        )
        
        rankBackgroundView.layer.cornerRadius = 20
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rankCircleView.layer.cornerRadius = rankCircleView.frame.width / 2
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func fetchUserFriendData() {
        
        friendManager.fetchFriendListData(
        fetchUserID: userID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let userFriend):
                
                strongSelf.blockadeList = userFriend.blockadeList
                
                strongSelf.rankTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
            }
                
        }
        
    }
    
    func listenUsersInfoData() {
        
        friendManager.listenFriendInfoData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let usersInfo):
                
                let sortUserInfo = usersInfo.sorted { (lhs, rhs) in
                    
                    return lhs.achievement.experienceValue > rhs.achievement.experienceValue
                    
                }
                
                strongSelf.usersInfo = sortUserInfo
                
                strongSelf.fetchUserFriendData()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.rankTableView)
            
            if let indexPath = rankTableView.indexPathForRow(at: touchPoint) {
                
                // 彈跳出 User 視窗
                guard let viewController = UIStoryboard
                    .chat
                    .instantiateViewController(
                    withIdentifier: String(describing: UserInfoViewController.self)
                    ) as? UserInfoViewController else { return }
                
                viewController.deleteAccount = false
                
                viewController.selectUserID = usersInfo[indexPath.row].userID
                
                self.view.addSubview(viewController.view)

                self.addChild(viewController)
                
            }
            
        }
        
    }
    
}

extension RankViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersInfo.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: RankTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? RankTableViewCell else { return cell }
        
        cell.showRankData(
            rankNumber: indexPath.row + 1, userInfo: usersInfo[indexPath.row], blockadeList: blockadeList)
        
        return cell
        
    }
    
}