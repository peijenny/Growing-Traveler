//
//  UserInfoViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/4.
//

import UIKit
import PKHUD

class UserInfoViewController: UIViewController {

    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var friendStatusLabel: UILabel!
    
    @IBOutlet weak var blockUserButton: UIButton!
    
    @IBOutlet weak var addUserButton: UIButton!
    
    var friendManager = FriendManager()
    
    var userManager = UserManager()
    
    var userInfo: UserInfo?
    
    var ownerFriend: Friend?
    
    var otherFriend: Friend?
    
    var bothSides: BothSides?
    
    var selectUserID: String?
    
    var deleteAccount = Bool()

    var getFriendStatus: ((_ isBlock: Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if selectUserID == userID {
            
            friendStatusLabel.text = SearchFriendStatus.yourInfo.title
            
        } else if userID == "" {
            
            friendStatusLabel.text = "請先登入會員才能加入或封鎖帳號！"
            
        }
        
        if !deleteAccount {
            
            fetchFriendListData(userID: userID)
            
            fetchFriendListData(userID: selectUserID ?? "")
            
            fetchUserInfoData(userID: selectUserID ?? "")
            
        } else {
            
            userNameLabel.text = "已刪除帳號的使用者"
            
            friendStatusLabel.text = SearchFriendStatus.deleteAccount.title
            
            blockUserButton.isEnabled = false
            
            addUserButton.isEnabled = false
            
        }
        
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
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
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
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func showUserInfo() {
        
        if userInfo?.userPhoto != "" {
            
            userPhotoImageView.loadImage(userInfo?.userPhoto)
            
        } else {
            
            userPhotoImageView.image = UIImage.asset(.userIcon)
            
        }
        
        userNameLabel.text = userInfo?.userName ?? ""
        
    }
    
    func handleFriendStatus() {
        
        blockUserButton.isEnabled = false
        
        addUserButton.isEnabled = false

        guard let friendList = ownerFriend else { return }

        if friendList.blockadeList.filter({ $0 == selectUserID }).isEmpty {
            
            userPhotoImageView.image = UIImage.asset(.block)
            
            userNameLabel.text = "已封鎖的使用者"
            
            friendStatusLabel.text = SearchFriendStatus.blocked.title
            
        } else if friendList.friendList.filter({ $0 == selectUserID }).isEmpty {
            
            friendStatusLabel.text = SearchFriendStatus.friendship.title
            
            blockUserButton.isEnabled = true
            
        } else if friendList.deliveryList.filter({ $0 == selectUserID }).isEmpty {
            
            friendStatusLabel.text = SearchFriendStatus.invitaion.title
            
            blockUserButton.isEnabled = true
            
        } else if friendList.applyList.filter({ $0 == selectUserID }).isEmpty {
            
            friendStatusLabel.text = SearchFriendStatus.applied.title
            
            blockUserButton.isEnabled = true
            
        } else {
            
            blockUserButton.isEnabled = true
            
            addUserButton.isEnabled = true
            
            friendStatusLabel.text = SearchFriendStatus.noRelation.title
            
            if let ownerFriend = ownerFriend, let otherFriend = otherFriend {

                bothSides = BothSides(owner: ownerFriend, other: otherFriend)

            }
            
        }
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func blockUserButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(
            title: "封鎖帳號", message: "請問確定封鎖此帳號嗎？\n 將不再看到此帳號的相關文章及訊息！", preferredStyle: .alert)
        
        let agreeAction = UIAlertAction(title: "確認", style: .destructive) { _ in
            
            if var ownerFriend = self.ownerFriend {
                
                ownerFriend.blockadeList.append(self.selectUserID ?? "")
                
                self.friendManager.updateData(friend: ownerFriend)
                
                self.view.removeFromSuperview()
                
                self.getFriendStatus?(true)
                
            }

        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alertController.addAction(agreeAction)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func addUserButton(_ sender: UIButton) {

        if var bothSides = bothSides {
            
            bothSides.owner.deliveryList.append(selectUserID ?? "")
            
            bothSides.other.applyList.append(userID)
            
            friendManager.addFriendData(bothSides: bothSides, confirmType: ConfirmType.apply.title)
            
            HUD.flash(.labeledSuccess(title: "已發送好友邀請!", subtitle: "請等待對方的回覆"), delay: 0.5)
            
            self.view.removeFromSuperview()
            
        }
        
    }
    
}
