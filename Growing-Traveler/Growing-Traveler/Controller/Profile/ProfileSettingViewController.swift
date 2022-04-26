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
    
    var userInfo: UserInfo? {
        
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
        
    }
    
    @objc func modifyUserPhoto(sender: UIButton) {
        
    }
    
}