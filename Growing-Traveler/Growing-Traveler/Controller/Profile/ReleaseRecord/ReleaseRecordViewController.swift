//
//  ReleaseRecordViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/28.
//

import UIKit
import PKHUD

class ReleaseRecordViewController: UIViewController {

    var releaseRecordTableView = UITableView()
    
    var resleaseBackgroundView = UIView()
    
    var placeHolderImageView = UIImageView()
    
    var placeHolderLabel = UILabel()
    
    var forumArticleManager = ForumArticleManager()
    
    var userManager = UserManager()
    
    var usersInfo: [UserInfo] = []
    
    var forumArticles: [ForumArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "發佈文章紀錄"
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)

        setNavigationItem()
        
        setBackgroundView()
        
        setTableView()
        
        setReleaseBackgroundView()
        
        setImageView()
        
        setLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserInfoData()
        
        fetchReleaseData()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func setNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.create), style: .plain, target: self, action: #selector(addForumArticle))
        
        navigationItem.backButtonTitle = ""
        
    }
    
    @objc func addForumArticle(sender: UIButton) {
        
        guard !KeyToken().userID.isEmpty else {

            guard let authViewController = UIStoryboard.auth.instantiateViewController(
                withIdentifier: String(describing: AuthenticationViewController.self)
            ) as? AuthenticationViewController else { return }
            
            authViewController.modalPresentationStyle = .formSheet

            present(authViewController, animated: true, completion: nil)
            
            return
            
        }

        let viewController = PublishForumArticleViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }

    func fetchUserInfoData() {
        
        userManager.fetchUsersInfo { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let usersInfo):
                
                self.usersInfo = usersInfo
                
                self.releaseRecordTableView.reloadData()
                
            case .failure:
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func fetchReleaseData() {
        
        forumArticleManager.fetchSearchData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let forumArticles):
                
                let filterArticles = forumArticles.filter({ $0.userID == KeyToken().userID })
                
                self.forumArticles = filterArticles
                
                if self.forumArticles.count == 0 {
                    
                    self.resleaseBackgroundView.isHidden = false
                    
                } else {
                    
                    self.resleaseBackgroundView.isHidden = true
                    
                }
                
                self.releaseRecordTableView.reloadData()
                
            case .failure:
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
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
    
    func setReleaseBackgroundView() {
        
        resleaseBackgroundView.backgroundColor = UIColor.clear
        
        resleaseBackgroundView.isHidden = true
        
        view.addSubview(resleaseBackgroundView)
        
        resleaseBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resleaseBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            resleaseBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resleaseBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resleaseBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -110.0)
        ])
        
    }
    
    func setImageView() {
        
        placeHolderImageView.image = UIImage.asset(.undrawNotFound)
        
        resleaseBackgroundView.addSubview(placeHolderImageView)
        
        placeHolderImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeHolderImageView.topAnchor.constraint(equalTo: resleaseBackgroundView.topAnchor, constant: 50),
            placeHolderImageView.trailingAnchor.constraint(
                equalTo: resleaseBackgroundView.trailingAnchor, constant: -50),
            placeHolderImageView.leadingAnchor.constraint(equalTo: resleaseBackgroundView.leadingAnchor, constant: 50),
            placeHolderImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    func setLabel() {
        
        placeHolderLabel.text = "目前暫無發佈紀錄"
        
        placeHolderLabel.textAlignment = .center
        
        resleaseBackgroundView.addSubview(placeHolderLabel)
        
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: placeHolderImageView.bottomAnchor, constant: 20),
            placeHolderLabel.trailingAnchor.constraint(equalTo: resleaseBackgroundView.trailingAnchor, constant: -50),
            placeHolderLabel.leadingAnchor.constraint(equalTo: resleaseBackgroundView.leadingAnchor, constant: 50),
            placeHolderLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
    }

    func setTableView() {
        
        releaseRecordTableView.backgroundColor = UIColor.clear
        
        releaseRecordTableView.separatorStyle = .none
        
        view.addSubview(releaseRecordTableView)
        
        releaseRecordTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            releaseRecordTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            releaseRecordTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            releaseRecordTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            releaseRecordTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -110.0)
        ])
        
        releaseRecordTableView.register(
            UINib(nibName: String(describing: MoreArticlesTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: MoreArticlesTableViewCell.self))

        releaseRecordTableView.delegate = self
        
        releaseRecordTableView.dataSource = self
        
    }

}

extension ReleaseRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forumArticles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MoreArticlesTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? MoreArticlesTableViewCell else { return cell }
        
        cell.selectionStyle = .none
        
        let userInfo = usersInfo.filter({ $0.userID == forumArticles[indexPath.row].userID })
        
        if !userInfo.isEmpty {
            
            let userName = userInfo[0].userName
            
            cell.showMoreArticles(forumArticle: forumArticles[indexPath.row], userName: userName)
            
        }
        
        cell.userInfoButton.isHidden = true
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = PublishForumArticleViewController()
        
        viewController.modifyForumArticle = forumArticles[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "刪除"
        
    }
    
    func tableView(
        _ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let alertController = UIAlertController(
                title: "刪除討論區發文", message: "請問確定刪除此篇文章嗎？\n 刪除行為不可逆，將無法瀏覽此文章！", preferredStyle: .alert)
            
            let agreeAction = UIAlertAction(title: "確認", style: .destructive) { _ in
                
                self.forumArticleManager.deleteData(forumArticle: self.forumArticles[indexPath.row])
                
                self.forumArticles.remove(at: indexPath.row)
                
                self.releaseRecordTableView.beginUpdates()

                self.releaseRecordTableView.deleteRows(at: [indexPath], with: .left)

                self.releaseRecordTableView.endUpdates()

            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            
            alertController.addAction(agreeAction)
            
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
            
    }
    
}
