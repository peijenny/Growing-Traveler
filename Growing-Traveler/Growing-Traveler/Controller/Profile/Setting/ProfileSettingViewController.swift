//
//  ProfileSettingViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit
import Firebase

class ProfileSettingViewController: BaseViewController {
    
    // MARK: - IBOutlet / Components
    var profileSettingTableView = UITableView()
    
    // MARK: - Property
    var deleteUserManager = DeleteUserManager()
    
    var friendManager = FriendManager()
    
    var userManger = UserManager()
    
    var forumArticles: [ForumArticle] = []
    
    var studyGoals: [StudyGoal] = []
    
    var userInfo: UserInfo? {
        
        didSet {
            
            profileSettingTableView.reloadData()
            
        }
        
    }
    
    var friendList: Friend?
    
    var userImageLink: String?
    
    var isCheck = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "個人設定"
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)

        setBackgroundView()
        
        setTableView()
        
        fetchUserInfoData()
        
        fetchAllData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(submitButton))

    }
    
    // MARK: - Set UI
    func setBackgroundView() {
        
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
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
            profileSettingTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileSettingTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileSettingTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            profileSettingTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -200.0)
        ])
        
        profileSettingTableView.register(
            UINib(nibName: String(describing: SettingImageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SettingImageTableViewCell.self))

        profileSettingTableView.register(
            UINib(nibName: String(describing: SettingContentTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SettingContentTableViewCell.self))
        
        profileSettingTableView.register(
            UINib(nibName: String(describing: SettingSignTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SettingSignTableViewCell.self))
        
        profileSettingTableView.delegate = self
        
        profileSettingTableView.dataSource = self
        
    }
    
    // MARK: - Method
    func fetchUserInfoData() {
        
        userManger.listenUserInfo { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let user):
                
                self.userInfo = user
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    // MARK: - Target / IBAction
    @objc func submitButton(sender: UIButton) {
        
        isCheck = true
        
        profileSettingTableView.reloadData()
        
    }
    
}

// MARK: - TableView delegate / dataSource
extension ProfileSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if indexPath.row == 0 {
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SettingImageTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SettingImageTableViewCell else { return cell }
            
            if userInfo?.userPhoto != "" {
                
                cell.setUserPhoto(userPhotoLink: userInfo?.userPhoto ?? "")
                
            }
            
            if userImageLink != nil {
                
                cell.setUserPhoto(userPhotoLink: userImageLink ?? "")
                
            }
            
            cell.modifyUserPhotoButton.addTarget(self, action: #selector(modifyUserPhoto), for: .touchUpInside)
            
        } else if indexPath.row == 1 {
            
            cell = tableView.dequeueReusableCell(
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
                        
                        userManger.updateUserInfo(user: updateUserInfo)
                        
                        friendList?.userName = cell.userNameTextField.text ?? ""
                        
                        if let friendList = friendList {
                            
                            friendManager.updateFriendList(friend: friendList)
                            
                        }
                        
                        HandleResult.updateDataSuccess.messageHUD
                        
                    }
                    
                }
                
                isCheck = false
                
            }
            
            cell.showUserContent(userInfo: userInfo)
            
        } else {
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SettingSignTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SettingSignTableViewCell else { return cell }
            
            cell.signOutAccountButton.addTarget(self, action: #selector(signOutAccount), for: .touchUpInside)
            
            cell.deleteAccountButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
            
            cell.privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButton), for: .touchUpInside)
            
            cell.eulaButton.addTarget(self, action: #selector(eulaButton), for: .touchUpInside)
            
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    @objc func privacyPolicyButton(sender: UIButton) {
        
        pushToPrivacyPolicyPage(privacyPolicyType: PrivacyPolicy.privacyPolicy.title)
        
    }
    
    @objc func eulaButton(sender: UIButton) {
        
        pushToPrivacyPolicyPage(privacyPolicyType: PrivacyPolicy.eula.title)
        
    }
    
    @objc func signOutAccount(sender: UIButton) {
        
        let firebaseAuth = Auth.auth()

        do {

            try firebaseAuth.signOut()

            KeyToken().userID = ""
            
            navigationController?.popViewController(animated: true)
            
            tabBarController?.selectedIndex = 0

        } catch {
            
            HandleResult.signOutFailed.messageHUD
            
        }
        
    }
    
    @objc func deleteAccount(sender: UIButton) {
        
        let alertController = UIAlertController(
            title: "刪除使用者帳號確認", message: "請問確定刪除使用者帳號？\n 刪除行為不可逆，資料將一併刪除！", preferredStyle: .alert)
        
        let agreeAction = UIAlertAction(title: "確認", style: .destructive) { _ in

            let user = Auth.auth().currentUser

            user?.delete { error in

                if error != nil {

                    HandleResult.deleteDataFailed.messageHUD

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
    
    @objc func modifyUserPhoto(sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
    func pushToPrivacyPolicyPage(privacyPolicyType: String) {
        
        let viewController = UIStoryboard.profile.instantiateViewController(
            withIdentifier: String(describing: PrivacyPolicyViewController.self))
        
        guard let viewController = viewController as? PrivacyPolicyViewController else { return }
        
        viewController.privacyTitle = privacyPolicyType
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func deleteAllData() {
        
        deleteUserManager.deleteUserInfoData(deleteUserID: KeyToken().userID)
        
        deleteUserManager.deleteStudyGoalsData(studyGoals: studyGoals)
        
        deleteUserManager.deleteForumArticlesData(forumArticles: forumArticles)
        
        deleteUserManager.deleteFriendListData(deleteUserID: KeyToken().userID)

        KeyToken().userID = ""
        
        self.navigationController?.popViewController(animated: true)
        
        self.tabBarController?.selectedIndex = 0
        
    }
    
    func fetchAllData() {
        
        deleteUserManager.fetchStudyGoalsData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let studyGoals):
                
                self.studyGoals = studyGoals
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
        deleteUserManager.fetchForumArticlesData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let forumArticles):
                
                self.forumArticles = forumArticles
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
        deleteUserManager.fetchFriendListData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let friendList):
                
                self.friendList = friendList
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
}

// MARK: - ImagePickerController delegate
extension ProfileSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let self = self else { return }

                switch result {

                case.success(let imageLink):
                    
                    self.userImageLink = "\(imageLink)"

                    self.profileSettingTableView.reloadData()
                    
                case .failure:
                    
                    HandleResult.readDataFailed.messageHUD

                }

            })

        }

        dismiss(animated: true)

    }
    
}
