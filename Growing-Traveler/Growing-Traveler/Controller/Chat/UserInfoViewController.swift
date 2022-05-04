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

    @IBOutlet weak var friendStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserInfo(userInfo: selectUserID ?? "")

    }
    
    func fetchUserInfo(userInfo: String) {
        
        userManager.fetchData(fetchUserID: userInfo) { [weak self] result in
            
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
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func blockUserButton(_ sender: UIButton) {
        
        // 加到 blockade list
    }
    
    @IBAction func addUserButton(_ sender: UIButton) {
        
        // 加到兩個 list 中
        
    }
    
}
