//
//  CertificationViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/29.
//

import UIKit

class CertificationViewController: UIViewController {
    
    // MARK: - IBOutlet / Components
    var certificationTableView = UITableView()
    
    var certificationBackgroundView = UIView()
    
    var placeHolderImageView = UIImageView()
    
    var placeHolderLabel = UILabel()
    
    // MARK: - Property
    var userManager = UserManager()
    
    var userInfo: UserInfo?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "個人認證"
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        setNavigationItem()
        
        setBackgroundView()
        
        setTableView()
        
        setCertificationBackgroundView()
        
        setImageView()
        
        setLabel()
        
        fetchUserInfoData()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    // MARK: - Set UI
    func setNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addCertification))
        
    }
    
    func setCertificationBackgroundView() {
        
        certificationBackgroundView.backgroundColor = UIColor.clear
        
        certificationBackgroundView.isHidden = true
        
        view.addSubview(certificationBackgroundView)
        
        certificationBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            certificationBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            certificationBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            certificationBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            certificationBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -110.0)
        ])
        
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
    
    func setImageView() {
        
        placeHolderImageView.image = UIImage.asset(.undrawNotFound)
        
        certificationBackgroundView.addSubview(placeHolderImageView)
        
        placeHolderImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeHolderImageView.topAnchor.constraint(equalTo: certificationBackgroundView.topAnchor, constant: 50),
            placeHolderImageView.trailingAnchor.constraint(
                equalTo: certificationBackgroundView.trailingAnchor, constant: -50),
            placeHolderImageView.leadingAnchor.constraint(
                equalTo: certificationBackgroundView.leadingAnchor, constant: 50),
            placeHolderImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    func setLabel() {
        
        placeHolderLabel.text = "目前暫無考試認證"
        
        placeHolderLabel.textAlignment = .center
        
        certificationBackgroundView.addSubview(placeHolderLabel)
        
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: placeHolderImageView.bottomAnchor, constant: 20),
            placeHolderLabel.trailingAnchor.constraint(
                equalTo: certificationBackgroundView.trailingAnchor, constant: -50),
            placeHolderLabel.leadingAnchor.constraint(equalTo: certificationBackgroundView.leadingAnchor, constant: 50),
            placeHolderLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
    }
    
    func setTableView() {
        
        certificationTableView.backgroundColor = UIColor.clear
        
        certificationTableView.separatorStyle = .none
        
        view.addSubview(certificationTableView)
        
        certificationTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            certificationTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            certificationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            certificationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            certificationTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -110.0)
        ])
        
        certificationTableView.register(
            UINib(nibName: String(describing: CertificationTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: CertificationTableViewCell.self))

        certificationTableView.delegate = self
        
        certificationTableView.dataSource = self
        
    }
    
    // MARK: - Method
    func fetchUserInfoData() {
        
        userManager.listenUserInfo { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let userInfo):
                
                self.userInfo = userInfo
                
                if self.userInfo?.certification.count == 0 {
                    
                    self.certificationBackgroundView.isHidden = false
                    
                } else {
                    
                    self.certificationBackgroundView.isHidden = true
                    
                }
                
                self.certificationTableView.reloadData()
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    // MARK: - Target / IBAction
    @objc func addCertification(sender: UIButton) {
        
        guard let viewController = UIStoryboard.profile.instantiateViewController(
            withIdentifier: String(describing: PublishCertificationViewController.self)
        ) as? PublishCertificationViewController else { return }
        
        viewController.userInfo = userInfo
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.addSubview(viewController.view)

        self.addChild(viewController)
        
    }

}

// MARK: - TableView delegate / dataSource
extension CertificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userInfo?.certification.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CertificationTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? CertificationTableViewCell else { return cell }
        
        if let certification = userInfo?.certification[indexPath.row] {
            
            cell.showCertificationData(certification: certification)
            
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let viewController = UIStoryboard.profile.instantiateViewController(
            withIdentifier: String(describing: PublishCertificationViewController.self)
        ) as? PublishCertificationViewController else { return }
        
        viewController.userInfo = userInfo
        
        viewController.modifyCertificationIndex = indexPath.row
        
        self.view.addSubview(viewController.view)

        self.addChild(viewController)
        
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
                title: "刪除個人認證", message: "請問確定刪除個人認證嗎？\n 刪除行為不可逆，將無法瀏覽此認證！", preferredStyle: .alert)
            
            let agreeAction = UIAlertAction(title: "確認", style: .destructive) { _ in

                self.userInfo?.certification.remove(at: indexPath.row)
                
                self.certificationTableView.beginUpdates()

                self.certificationTableView.deleteRows(at: [indexPath], with: .left)

                self.certificationTableView.endUpdates()
                
                if let userInfo = self.userInfo {
                 
                    self.userManager.updateUserInfo(user: userInfo)
                    
                }
                
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            
            alertController.addAction(agreeAction)
            
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
            
    }
    
}
