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
    
    var friendManager = FriendManager()
    
    var usersInfo: [UserInfo] = [] {
        
        didSet {
            
            rankTableView.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "成長排行榜"
        
        listenUsersInfoData()
        
        rankTableView.register(
            UINib(nibName: String(describing: RankTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: RankTableViewCell.self)
        )
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
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
                
            case .failure(let error):
                
                print(error)
                
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
        rankNumber: indexPath.row + 1, userInfo: usersInfo[indexPath.row])
        
        return cell
        
    }
    
}
