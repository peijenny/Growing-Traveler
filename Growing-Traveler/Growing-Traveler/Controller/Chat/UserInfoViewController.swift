//
//  UserInfoViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/4.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var selectUserID: String?
    
    var userManager = UserManager()
    
    var userInfo: UserInfo?
    
    var bothSides: BothSides?
    
    var isBlock = Bool()
    
    var deleteAccount = Bool()
    
    var friendManager = FriendManager()
    
    var ownerFriend: Friend?
    
    var otherFriend: Friend?

    @IBOutlet weak var friendStatusLabel: UILabel!
    
    @IBOutlet weak var blockUserButton: UIButton!
    
    @IBOutlet weak var addUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFriendListData(userID: userID)
        
        fetchFriendListData(userID: selectUserID ?? "")
        
        fetchUserInfoData(userID: selectUserID ?? "")

    }
    
    func fetchFriendListData(userID: String) {
        
        friendManager.fetchFriendListData(fetchUserID: userID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let friendList):
                
                if userID == strongSelf.selectUserID {
                    
                    strongSelf.otherFriend = friendList
                    
                } else {
                    
                    strongSelf.ownerFriend = friendList
                    
                }
                
                strongSelf.handleFriendStatus()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func fetchUserInfoData(userID: String) {
        
        userManager.fetchData(fetchUserID: userID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let userInfo):
                
                strongSelf.userInfo = userInfo
                
                strongSelf.showUserInfo()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func showUserInfo() {
        
        if userInfo?.userPhoto != "" {
            
            userPhotoImageView.loadImage(userInfo?.userPhoto)
            
        }
        
        userNameLabel.text = userInfo?.userName ?? ""
        
    }
    
    func handleFriendStatus() {
        
        blockUserButton.isEnabled = false
        
        addUserButton.isEnabled = false

        guard let friendList = ownerFriend else { return }
        
        if friendList.blockadeList.filter({ $0 == selectUserID }).count > 0 {
            
            friendStatusLabel.text = SearchFriendStatus.blocked.title
            
        } else if friendList.friendList.filter({ $0 == selectUserID }).count > 0 {
            
            friendStatusLabel.text = SearchFriendStatus.friendship.title
            
            blockUserButton.isEnabled = true
            
        } else if friendList.deliveryList.filter({ $0 == selectUserID }).count > 0 {
            
            friendStatusLabel.text = SearchFriendStatus.invitaion.title
            
            blockUserButton.isEnabled = true
            
        } else if friendList.applyList.filter({ $0 == selectUserID }).count > 0 {
            
            friendStatusLabel.text = SearchFriendStatus.applied.title
            
            blockUserButton.isEnabled = true
            
        } else if userInfo == nil {
            
            friendStatusLabel.text = SearchFriendStatus.deleteAccount.title
            
        } else {
            
            blockUserButton.isEnabled = false
            
            addUserButton.isEnabled = false
            
            if let ownerFriend = ownerFriend, let otherFriend = otherFriend {
                
                bothSides = BothSides(owner: ownerFriend, other: otherFriend)
                
            }
            
        }
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func blockUserButton(_ sender: UIButton) {
        
        // 加到 blockade list
        
        if var bothSides = bothSides {
            
            bothSides.owner.deliveryList.append(selectUserID ?? "")
            
            bothSides.other.applyList.append(userID)
            
            print("TEST 自己的申請 \(bothSides.owner.deliveryList)")
            
            print("TEST 對方的申請 \(bothSides.other.applyList)")
            
//            friendManager.addFriendData(bothSides: bothSides, confirmType: ConfirmType.apply.title)
            
        }
        
    }
    
    @IBAction func addUserButton(_ sender: UIButton) {
        
        // 加到兩個 list 中
        
        if var bothSides = bothSides {
            
            bothSides.owner.deliveryList.append(selectUserID ?? "")
            
            bothSides.other.applyList.append(userID)
            
            print("TEST 自己的申請 \(bothSides.owner.deliveryList)")
            
            print("TEST 對方的申請 \(bothSides.other.applyList)")
            
//            friendManager.addFriendData(bothSides: bothSides, confirmType: ConfirmType.apply.title)
            
        }
        
    }
    
}
