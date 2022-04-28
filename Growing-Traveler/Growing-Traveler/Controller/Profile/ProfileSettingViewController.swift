//
//  ProfileSettingViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit
import Firebase

class ProfileSettingViewController: BaseViewController {
    
    var profileSettingTableView = UITableView()
    
    var userManger = UserManager()
    
    var deleteUserManager = DeleteUserManager()
    
    var studyGoals: [StudyGoal] = []  // 使用者建立的學習目標 (多筆)
    
    var friendList: Friend? // 使用者的 Friend 資料 (1筆)
    
    var forumArticles: [ForumArticle] = [] // 使用者發布的 Forum 文章 (多筆)
//
//    var deleteArticleMessages: [DeleteArticle] = [] // 使用者於 Forum 文章下的留言 (多筆)
//
//    var allForumArticles: [ForumArticle] = [] {   // 所有使用者發佈的文章
//
//        didSet {
//
//            fetchArticleMessageData(allForumArticles: allForumArticles)
//
//        }
//
//    }
    
    var userInfo: UserInfo? {  // 使用者資料 (1筆)
        
        didSet {
            
            profileSettingTableView.reloadData()
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "個人設定"
        
        view.backgroundColor = UIColor.white

        setTableView()
        
        fetchData()
        
        fetchAllData()
        
    }
    
    func setTableView() {
        
        profileSettingTableView.backgroundColor = UIColor.clear
        
        profileSettingTableView.separatorStyle = .none
        
        view.addSubview(profileSettingTableView)
        
        profileSettingTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileSettingTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileSettingTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileSettingTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            profileSettingTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -160.0)
        ])
        
        profileSettingTableView.register(
            UINib(nibName: String(describing: SettingImageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SettingImageTableViewCell.self)
        )

        profileSettingTableView.register(
            UINib(nibName: String(describing: SettingContentTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SettingContentTableViewCell.self)
        )
        
        profileSettingTableView.register(
            UINib(nibName: String(describing: SettingSignTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SettingSignTableViewCell.self)
        )
        
        profileSettingTableView.delegate = self
        
        profileSettingTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
    }
    
    func fetchData() {
        
        userManger.fetchData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let user):
                
                strongSelf.userInfo = user
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
}

extension ProfileSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SettingImageTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SettingImageTableViewCell else { return cell }
            
            cell.userPhotoImageView.loadImage(userInfo?.userPhoto)
            
            cell.modifyUserPhotoButton.addTarget(self, action: #selector(modifyUserPhoto), for: .touchUpInside)
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SettingContentTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SettingContentTableViewCell else { return cell }
            
            cell.userIDTextField.text = userInfo?.userID
            
            cell.userNameTextField.text = userInfo?.userName
            
            cell.userEmailTextField.text = userInfo?.userEmail
            
            cell.userPhoneTextField.text = userInfo?.userPhone
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SettingSignTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SettingSignTableViewCell else { return cell }
            
            cell.signOutAccountButton.addTarget(self, action: #selector(signOutAccount), for: .touchUpInside)
            
            cell.deleteAccountButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)

            return cell
            
        }
        
    }
    
    @objc func signOutAccount(sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
        tabBarController?.selectedIndex = 0
        
        let firebaseAuth = Auth.auth()

        do {

            try firebaseAuth.signOut()

            userID = ""

        } catch let signOutError as NSError {

            print("Error signing out: %@", signOutError)

        }
        
    }
    
    @objc func deleteAccount(sender: UIButton) {
        
        let alertController = UIAlertController(
            title: "刪除使用者帳號確認",
            message: "請問確定刪除此使用者帳號？\n 刪除行為不可逆，資料將一併刪除！",
            preferredStyle: .alert)
        
        let agreeAction = UIAlertAction(title: "確認", style: .default) { _ in

            let user = Auth.auth().currentUser

            user?.delete { error in

                if let error = error {

                    print(error)

                } else {
                    
                    print("TEST success")
                    
                    self.deleteAllData()

                }

            }
            
            self.navigationController?.popViewController(animated: true)
            
            self.tabBarController?.selectedIndex = 0
            
            print("帳號已刪除！")
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alertController.addAction(agreeAction)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func deleteAllData() {
        
        deleteUserManager.deleteUserInfoData(deleteUserID: userID)
        
        deleteUserManager.deleteStudyGoalsData(studyGoals: studyGoals)
        
        deleteUserManager.deleteForumArticlesData(forumArticles: forumArticles)
        
        deleteUserManager.deleteFriendListData(deleteUserID: userID)
        
//        deleteUserManager.deleteAllArticleMessagesData(deleteArticleMessages: deleteArticleMessages)
        
        userID = ""
        
    }
    
    func fetchAllData() {
        
        deleteUserManager.fetchStudyGoalsData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let studyGoals):
                
                strongSelf.studyGoals = studyGoals
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
        deleteUserManager.fetchForumArticlesData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let forumArticles):
                
                strongSelf.forumArticles = forumArticles
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
//        deleteUserManager.fetchAllForumArticlesData { [weak self] result in
//
//            guard let strongSelf = self else { return }
//
//            switch result {
//
//            case .success(let allForumArticles):
//
//                strongSelf.allForumArticles = allForumArticles
//
//            case .failure(let error):
//
//                print(error)
//
//            }
//
//        }
        
        deleteUserManager.fetchFriendListData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let friendList):
                
                strongSelf.friendList = friendList
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
//    func fetchArticleMessageData(allForumArticles: [ForumArticle]) {
//
//        deleteUserManager.fetchArticleMessagesData(
//        allForumArticles: allForumArticles) { [weak self] result in
//
//            guard let strongSelf = self else { return }
//
//            switch result {
//
//            case .success(let deleteArticleMessages):
//
//                for index in 0..<deleteArticleMessages.count {
//
//                    let filterDeleteArticles = deleteArticleMessages[index].articleMessage.filter({ $0.userID == userID })
//
//                    let deleteArticles = DeleteArticle(articleID: deleteArticleMessages[index].articleID, articleMessage: filterDeleteArticles)
//
//                    strongSelf.deleteArticleMessages.append(deleteArticles)
//                }
//
////                strongSelf.deleteArticleMessages = deleteArticleMessages
//
//            case .failure(let error):
//
//                print(error)
//
//            }
//
//        }
//
//    }
    
    @objc func modifyUserPhoto(sender: UIButton) {
        
    }
    
}
