//
//  CertificationViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/29.
//

import UIKit

class CertificationViewController: UIViewController {

    var certificationTableView = UITableView()
    
    var userManager = UserManager()
    
    var userInfo: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "個人認證"
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        setBackgroundView()
        
        setTableView()
        
        setNavigationItems()
        
        fetchUserInfoData()
        
    }
    
    func fetchUserInfoData() {
        
        userManager.fetchData(fetchUserID: userID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let userInfo):
                
                strongSelf.userInfo = userInfo
                
                strongSelf.certificationTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func setNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self,
            action: #selector(addCertification)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func addCertification(sender: UIButton) {
        
        guard let viewController = UIStoryboard.profile.instantiateViewController(
                withIdentifier: String(describing: PublishCertificationViewController.self)
                ) as? PublishCertificationViewController else { return }
        
        viewController.userInfo = userInfo
        
        self.view.addSubview(viewController.view)

        self.addChild(viewController)
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
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
        
        certificationTableView.backgroundColor = UIColor.clear
        
        certificationTableView.separatorStyle = .none
        
        view.addSubview(certificationTableView)
        
        certificationTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            certificationTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            certificationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            certificationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            certificationTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -160.0)
        ])
        
        certificationTableView.register(
            UINib(nibName: String(describing: CertificationTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: CertificationTableViewCell.self)
        )

        certificationTableView.delegate = self
        
        certificationTableView.dataSource = self
        
    }

}

extension CertificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
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
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let alertController = UIAlertController(
                title: "刪除個人認證",
                message: "請問確定刪除個人認證嗎？\n 刪除行為不可逆，將無法瀏覽此認證！",
                preferredStyle: .alert)
            
            let agreeAction = UIAlertAction(title: "確認", style: .default) { _ in

                self.userInfo?.certification.remove(at: indexPath.row)
                
                self.certificationTableView.beginUpdates()

                self.certificationTableView.deleteRows(at: [indexPath], with: .left)

                self.certificationTableView.endUpdates()
                
                if let userInfo = self.userInfo {
                 
                    self.userManager.updateData(user: userInfo)
                    
                }
                
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            
            alertController.addAction(agreeAction)
            
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
            
    }
    
}
