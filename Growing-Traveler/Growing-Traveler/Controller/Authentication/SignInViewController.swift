//
//  SignInViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit
import FirebaseAuth

class SignInViewController: BaseViewController {

    @IBOutlet weak var signTableView: UITableView! {
        
        didSet {
            
            signTableView.delegate = self
            
            signTableView.dataSource = self
            
        }
        
    }
   
    var signType = String()
    
    var userManager = UserManager()
    
    var friendManager = FriendManager()
    
    var isCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signTableView.register(
            UINib(nibName: String(describing: SignInTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SignInTableViewCell.self)
        )
        
        signTableView.register(
            UINib(nibName: String(describing: SignUpTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SignUpTableViewCell.self)
        )
        
    }

    @IBAction func backAuthPage(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension SignInViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if signType == SignType.signIn.title {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SignInTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SignInTableViewCell else { return cell }
            
            if isCheck == true {
                
                isCheck = false
                
                guard let signInContent = cell.getSignInData() else { return cell }
                
                sendSignInData(signInContent: signInContent)
                
            }
            
            cell.signInButton.addTarget(self, action: #selector(signInWithEmail), for: .touchUpInside)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SignUpTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SignUpTableViewCell else { return cell }
            
            if isCheck == true {
                
                isCheck = false
                
                guard let signUpContent = cell.getSignUpData() else { return cell }
                
                sendSignUpData(signUpContent: signUpContent)
                
            }
            
            cell.signUpButton.addTarget(self, action: #selector(signUpWithEmail), for: .touchUpInside)
            
            cell.uploadUserPhotoButton.addTarget(self, action: #selector(uploadUserPhoto), for: .touchUpInside)
            
            return cell
            
        }
        
    }
    
    @objc func signInWithEmail(sender: UIButton) {
        
        isCheck = true
        
        signTableView.reloadData()
        
    }
    
    @objc func signUpWithEmail(sender: UIButton) {
        
        isCheck = true
        
        signTableView.reloadData()
        
    }
    
    func sendSignInData(signInContent: SignIn) {

        if signInContent.email != "" &&  signInContent.password != "" {
            
            Auth.auth().signIn(
            withEmail: signInContent.email, password: signInContent.password) { result, error in
                
                guard let user = result?.user, error == nil else {
                    
                    if let error = error as? NSError {
                        
                        print(error)

                    }
                    
                    // 帳戶不存在?? -> 顯示動畫
                    return
                    
                }
                
                userID = user.uid
                
                self.dismiss(animated: true, completion: nil)
                
                self.removeFromParent()
                
            }
            
        }
        
    }
    
    func sendSignUpData(signUpContent: SignUp) {

        if signUpContent.email != "" &&  signUpContent.password != "" {
            
            Auth.auth().createUser(
            withEmail: signUpContent.email, password: signUpContent.password) { result, error in
                        
                guard let user = result?.user, error == nil else {
                    
                    if let error = error as? NSError {
                        
                        print(error)
                        
                    }
                    
                    // 註冊失敗?? -> 顯示動畫
                    return
                    
                }
                
                let userInfo = UserInfo(
                    userID: user.uid, userName: signUpContent.userName, userEmail: signUpContent.email,
                    userPhoto: signUpContent.userPhotoLink, userPhone: "",
                    achievement: Achievement(experienceValue: 0, completionGoals: [], loginDates: [])
                )
                
                self.userManager.addData(user: userInfo)
                
                let friend = Friend(
                    userID: user.uid, friendList: [], blockadeList: [],
                    applyList: [], deliveryList: []
                )
                
                self.friendManager.addData(friend: friend)
                
                userID = user.uid
                
                self.dismiss(animated: true, completion: nil)
                
                self.removeFromParent()

            }
            
        }
        
    }
    
    @objc func uploadUserPhoto(sender: UIButton) {
        
    }
    
}
