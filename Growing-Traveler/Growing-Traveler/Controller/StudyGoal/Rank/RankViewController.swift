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
            
        }
        
    }
    
    @IBOutlet weak var rankBackgroundView: UIView!
    
    @IBOutlet weak var rankCircleView: UIView!
    
    var friendManager = FriendManager()
    
    var blockadeList: [String] = []
    
    var usersInfo: [UserInfo] = [] {
        
        didSet {
            
            rankTableView.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "成長排行榜"
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        listenUsersInfoData()
        
        registerTableViewCell()
        
        rankBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
        rankCircleView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rankBackgroundView.layer.cornerRadius = 20
        
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
        fetchUserID: KeyToken().userID) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let userFriend):
                
                self.blockadeList = userFriend.blockadeList
                
                self.rankTableView.reloadData()
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
                
        }
        
    }
    
    func listenUsersInfoData() {
        
        friendManager.listenFriendInfoData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let usersInfo):
                
                let sortUserInfo = usersInfo.sorted { (lhs, rhs) in
                    
                    return lhs.achievement.experienceValue > rhs.achievement.experienceValue
                    
                }
                
                self.usersInfo = sortUserInfo
                
                if !KeyToken().userID.isEmpty {
                    
                    self.fetchUserFriendData()
                    
                }
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    func registerTableViewCell() {
        
        rankTableView.register(
            UINib(nibName: String(describing: RankTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: RankTableViewCell.self))
        
    }
    
}

extension RankViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersInfo.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: RankTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? RankTableViewCell else { return cell }
        
        cell.showRankData(
            rankNumber: indexPath.row + 1, userInfo: usersInfo[indexPath.row], blockadeList: blockadeList)
        
        cell.userInfoButton.addTarget(self, action: #selector(showUserInfoButton), for: .touchUpInside)
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    @objc func showUserInfoButton(sender: UIButton) {
     
        let point = sender.convert(CGPoint.zero, to: rankTableView)

        if let indexPath = rankTableView.indexPathForRow(at: point) {
            
            guard let viewController = UIStoryboard.chat.instantiateViewController(
                withIdentifier: String(describing: UserInfoViewController.self)
            ) as? UserInfoViewController else { return }
            
            viewController.deleteAccount = false
            
            viewController.selectUserID = usersInfo[indexPath.row].userID
            
            viewController.blockContentType = BlockContentType.user.title
            
            viewController.getFriendStatus = { [weak self] isBlock in
                
                guard let self = self else { return }
                
                if isBlock {
                    
                    self.listenUsersInfoData()
                    
                }
                
            }
            
            self.view.addSubview(viewController.view)

            self.addChild(viewController)
            
        }
    }
    
}
