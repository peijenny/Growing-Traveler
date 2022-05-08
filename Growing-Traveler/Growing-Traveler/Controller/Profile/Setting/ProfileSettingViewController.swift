//
//  ProfileSettingViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit
import Firebase
import PKHUD

class ProfileSettingViewController: BaseViewController {
    
    var profileSettingTableView = UITableView()
    
    var userManger = UserManager()
    
    var deleteUserManager = DeleteUserManager()
    
    var friendManager = FriendManager()
    
    var studyGoals: [StudyGoal] = []
    
    var friendList: Friend?
    
    var forumArticles: [ForumArticle] = []
    
    var userInfo: UserInfo? {
        
        didSet {
            
            profileSettingTableView.reloadData()
            
        }
        
    }
    
    var userImageLink: String?
    
    var isCheck = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "個人設定"
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)

        setBackgroundView()
        
        setTableView()
        
        fetchUserInfoData()
        
        fetchAllData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(submitButton))

    }
    
    @objc func submitButton(sender: UIButton) {
        
        isCheck = true
        
        profileSettingTableView.reloadData()
        
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
        
        profileSettingTableView.backgroundColor = UIColor.clear
        
        profileSettingTableView.separatorStyle = .none
        
        view.addSubview(profileSettingTableView)
        
        profileSettingTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileSettingTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileSettingTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileSettingTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            profileSettingTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -110.0)
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        tabBarController?.tabBar.isHidden = false
//
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        tabBarController?.tabBar.isHidden = true
//
//    }
    
    func fetchUserInfoData() {
        
        userManger.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let user):
                
                strongSelf.userInfo = user
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
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
            
            if userInfo?.userPhoto != "" {
                
                cell.setUserPhoto(userPhotoLink: userInfo?.userPhoto ?? "")
                
            }
            
            if userImageLink != nil {
                
                cell.setUserPhoto(userPhotoLink: userImageLink ?? "")
                
            }
            
            cell.modifyUserPhotoButton.addTarget(self, action: #selector(modifyUserPhoto), for: .touchUpInside)
            
            cell.selectionStyle = .none
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SettingContentTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SettingContentTableViewCell else { return cell }
            
            guard let userInfo = self.userInfo else { return cell }
            
            if isCheck {
                
                if cell.checkFullIn(userInfo: userInfo) != nil {
                    
                    self.userInfo = cell.checkFullIn(userInfo: userInfo)
                    
                    if userImageLink != nil {
                        
                        self.userInfo?.userPhoto = userImageLink ?? ""
                        
                    }
                    
                    if let updateUserInfo = self.userInfo {
                        
                        userManger.updateData(user: updateUserInfo)
                        
                        friendList?.userName = cell.userNameTextField.text ?? ""
                        
                        if let friendList = friendList {
                            
                            friendManager.updateData(friend: friendList)
                            
                        }
                        
                        HUD.flash(.labeledSuccess(title: "修改成功！", subtitle: nil), delay: 0.5)
                        
                    }
                    
                }
                
                isCheck = false
                
            }
            
            cell.showUserContent(userInfo: userInfo)
            
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SettingSignTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SettingSignTableViewCell else { return cell }
            
            cell.signOutAccountButton.addTarget(self, action: #selector(signOutAccount), for: .touchUpInside)
            
            cell.deleteAccountButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)

            cell.selectionStyle = .none
            
            return cell
            
        }
        
    }
    
    @objc func signOutAccount(sender: UIButton) {
        
        let firebaseAuth = Auth.auth()

        do {

            try firebaseAuth.signOut()

            userID = ""
            
            navigationController?.popViewController(animated: true)
            
            tabBarController?.selectedIndex = 0

        } catch let signOutError as NSError {

            print("Error signing out: %@", signOutError)

        }
        
    }
    
    @objc func deleteAccount(sender: UIButton) {
        
        let alertController = UIAlertController(
            title: "刪除使用者帳號確認",
            message: "請問確定刪除此使用者帳號？\n 刪除行為不可逆，資料將一併刪除！",
            preferredStyle: .alert)
        
        let agreeAction = UIAlertAction(title: "確認", style: .destructive) { _ in

            let user = Auth.auth().currentUser

            user?.delete { error in

                if let error = error {

                    print(error)
                    
                    HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

                } else {
                    
                    self.deleteAllData()

                }

            }
            
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

        userID = ""
        
        self.navigationController?.popViewController(animated: true)
        
        self.tabBarController?.selectedIndex = 0
        
        print("帳號已刪除！")
        
    }
    
    func fetchAllData() {
        
        deleteUserManager.fetchStudyGoalsData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let studyGoals):
                
                strongSelf.studyGoals = studyGoals
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
        deleteUserManager.fetchForumArticlesData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let forumArticles):
                
                strongSelf.forumArticles = forumArticles
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
        deleteUserManager.fetchFriendListData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let friendList):
                
                strongSelf.friendList = friendList
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }

    @objc func modifyUserPhoto(sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
}

extension ProfileSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let strongSelf = self else { return }

                switch result {

                case.success(let imageLink):
                    
                    strongSelf.userImageLink = "\(imageLink)"

                    strongSelf.profileSettingTableView.reloadData()
                    
                case .failure(let error):

                    print(error)
                    
                    HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

                }

            })

        }

        dismiss(animated: true)

    }
    
}
