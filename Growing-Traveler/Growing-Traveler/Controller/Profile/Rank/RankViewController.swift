//
//  RankViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/28.
//

import UIKit

class RankViewController: UIViewController {

    var friendManager = FriendManager()
    
    var usersInfo: [UserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "成長排行榜"
        
        listenUsersInfoData()
        
    }
    
    func listenUsersInfoData() {
        
        friendManager.listenFriendInfoData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let usersInfo):
                
                strongSelf.usersInfo = usersInfo
                
                print("TEST \(strongSelf.usersInfo)")
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
}
