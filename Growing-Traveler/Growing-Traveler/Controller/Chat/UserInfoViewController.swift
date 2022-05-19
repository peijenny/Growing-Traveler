//
//  UserInfoViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/4.
//

import UIKit
import PKHUD

class UserInfoViewController: UIViewController {

//    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var friendStatusLabel: UILabel!
    
    @IBOutlet weak var blockUserButton: UIButton!
    
    @IBOutlet weak var addUserButton: UIButton!
    
    @IBOutlet weak var reportPublishedButton: UIButton!
    
    var friendManager = FriendManager()
    
    var userManager = UserManager()
    
    var reportManager = ReportManager()
    
    var userInfo: UserInfo?
    
    var ownerFriend: Friend?
    
    var otherFriend: Friend?
    
    var bothSides: BothSides?
    
    var selectUserID: String?
    
    var deleteAccount = Bool()

    var getFriendStatus: ((_ isBlock: Bool) -> Void)?
    
    var articleID: String?  // 檢舉文章
    
    var articleMessage: ArticleMessage? // 檢舉留言
    
    var reportContentType: String? // 檢舉類型
    
    var blockContentType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if reportContentType == nil {

            reportPublishedButton.isHidden = true

        }
        
//        blockUserButton.setTitle(blockContentType ?? "", for: .normal)
        
        reportPublishedButton.setTitle(reportContentType ?? "", for: .normal)
        
        blockUserButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        addUserButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.salviaBlue.hexText)
        
        reportPublishedButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.blue.hexText)
        
        blockUserButton.cornerRadius = 5

        addUserButton.cornerRadius = 5
        
        reportPublishedButton.cornerRadius = 5
        
        friendStatusLabel.textColor = UIColor.hexStringToUIColor(hex: ColorChat.lightRed.hexText)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if selectUserID == KeyToken().userID {
            
            friendStatusLabel.text = SearchFriendStatus.yourInfo.title
            
        } else if KeyToken().userID == "" {
            
            friendStatusLabel.text = "請先登入會員才能加入或封鎖帳號！"
            
        }
        
        if !deleteAccount {
            
            fetchFriendListData(userID: KeyToken().userID)
            
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
        
//        if userInfo?.userPhoto != "" {
//
//            userPhotoImageView.loadImage(userInfo?.userPhoto)
//
//        } else {
//
//            userPhotoImageView.image = UIImage.asset(.userIcon)
//
//        }
        
        userNameLabel.text = userInfo?.userName ?? ""
        
    }
    
    func handleFriendStatus() {
        
        blockUserButton.isEnabled = false
        
        addUserButton.isEnabled = false

        guard let friendList = ownerFriend else { return }

        if !friendList.blockadeList.filter({ $0 == selectUserID }).isEmpty {
            
//            userPhotoImageView.image = UIImage.asset(.block)
            
            userNameLabel.text = "已封鎖的使用者"
            
            friendStatusLabel.text = SearchFriendStatus.blocked.title
            
        } else if !friendList.friendList.filter({ $0 == selectUserID }).isEmpty {
            
            friendStatusLabel.text = SearchFriendStatus.friendship.title
            
            blockUserButton.isEnabled = true
            
        } else if !friendList.deliveryList.filter({ $0 == selectUserID }).isEmpty {
            
            friendStatusLabel.text = SearchFriendStatus.invitaion.title
            
            blockUserButton.isEnabled = true
            
        } else if !friendList.applyList.filter({ $0 == selectUserID }).isEmpty {
            
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
            title: "封鎖", message: "請問確定\(blockContentType ?? "")嗎？\n 將無法再看到相關內容！", preferredStyle: .alert)
        
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
            
            bothSides.other.applyList.append(KeyToken().userID)
            
            friendManager.addFriendData(bothSides: bothSides, confirmType: ConfirmType.apply.title)
            
            HUD.flash(.labeledSuccess(title: "已發送好友邀請!", subtitle: "請等待對方的回覆"), delay: 0.5)
            
            self.view.removeFromSuperview()
            
        }
        
    }
    
    @IBAction func reportPublishedButton(_ sender: UIButton) {
        
        var reportInputText = ""
        
        let controller = UIAlertController(title: "檢舉", message: "請描述您要檢舉的內容", preferredStyle: .alert)
        
        controller.addTextField { textField in
            
           textField.placeholder = "檢舉內容"
        }

        let agreeAction = UIAlertAction(title: "確認", style: .default) { [unowned controller] _ in
            
            reportInputText = controller.textFields?[0].text ?? ""
            
            let createTime = TimeInterval(Int(Date().timeIntervalSince1970))
            
            let reportContent = ReportContent(
                reportID: self.reportManager.database.document().documentID,
                userID: KeyToken().userID, reportedUserID: self.selectUserID ?? "",
                reportType: self.reportContentType ?? "", reportContent: reportInputText,
                createTime: createTime, friendID: self.selectUserID ?? nil,
                articleID: self.articleID ?? nil, articleMessage: self.articleMessage ?? nil)
            
            self.reportManager.addReportData(reportContent: reportContent)
            
            HUD.flash(.labeledSuccess(title: "檢舉成功！", subtitle: "站方會盡快處理此檢舉"), delay: 0.5)
            
            self.view.removeFromSuperview()
            
        }
        
        controller.addAction(agreeAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
        
    }
    
}
