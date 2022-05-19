//
//  SignInViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit
import FirebaseAuth
import PKHUD

class SignInViewController: BaseViewController {

    @IBOutlet weak var signTableView: UITableView! {
        
        didSet {
            
            signTableView.delegate = self
            
            signTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    var friendManager = FriendManager()
    
    var errorManager = ErrorManager()
    
    var userManager = UserManager()
    
    var userImageLink: String?
    
    var signType = String()
    
    var isCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signTableView.register(
            UINib(nibName: String(describing: SignInTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SignInTableViewCell.self))
        
        signTableView.register(
            UINib(nibName: String(describing: SignUpTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SignUpTableViewCell.self))
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        backButton.tintColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
    }

    @IBAction func backAuthPage(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension SignInViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if signType == SignType.signIn.title {
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SignInTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SignInTableViewCell else { return cell }
            
            if isCheck == true {
                
                isCheck = false
                
                guard let signInContent = cell.getSignInData() else { return cell }
                
                sendSignInData(signInContent: signInContent)
                
            }
            
            cell.signInButton.addTarget(self, action: #selector(signInWithEmail), for: .touchUpInside)
            
        } else {
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SignUpTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SignUpTableViewCell else { return cell }
            
            if isCheck == true {
                
                isCheck = false
                
                guard let signUpContent = cell.getSignUpData() else { return cell }
                
                sendSignUpData(signUpContent: signUpContent)
                
            }
            
            if userImageLink != nil {
             
                cell.setUserPhoto(userPhotoLink: userImageLink ?? "")
                
            }
            
            cell.signUpButton.addTarget(self, action: #selector(signUpWithEmail), for: .touchUpInside)
            
            cell.uploadUserPhotoButton.addTarget(self, action: #selector(uploadUserPhoto), for: .touchUpInside)
            
        }
        
        cell.selectionStyle = .none
        
        return cell
        
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
            
            HUD.show(.labeledProgress(title: "登入中...", subtitle: nil))
            
            Auth.auth().signIn(
            withEmail: signInContent.email, password: signInContent.password) { result, error in
                
                guard let user = result?.user, error == nil else {
                    
                    if let error = error as? NSError {
                        
                        print(error)
                        
                        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                            
                            print("登入錯誤，於 firebase 無法找到配對的帳號！")
                            
                            HUD.flash(.labeledError(title: "登入失敗！", subtitle: "無法找到配對的帳號"))
                            
                            return
                            
                        }
                        
                        self.errorManager.handleAuthError(errorCode: errorCode)

                    }
                    
                    return
                    
                }
                
                HUD.flash(.labeledSuccess(title: "登入成功！", subtitle: nil), delay: 0.5)
                
                KeyToken().userID = user.uid
                
                self.view.window?.rootViewController?.viewWillAppear(true)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    func sendSignUpData(signUpContent: SignUp) {

        if signUpContent.email != "" &&  signUpContent.password != "" {
            
            HUD.show(.labeledProgress(title: "註冊中...", subtitle: nil))
            
            Auth.auth().createUser(
            withEmail: signUpContent.email, password: signUpContent.password) { result, error in
                        
                guard let user = result?.user, error == nil else {
                    
                    if let error = error as? NSError {
                        
                        print(error)
                        
                        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                            
                            print("註冊錯誤，於 firebase 無法找到配對的帳號！")
                            
                            HUD.flash(.labeledError(title: "註冊失敗！", subtitle: "無法找到配對的帳號"))
                            
                            return
                            
                        }
                        
                        self.errorManager.handleAuthError(errorCode: errorCode)
                        
                    }
                    
                    return
                    
                }
                
                HUD.flash(.labeledSuccess(title: "註冊成功！", subtitle: nil), delay: 0.5)

                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy.MM.dd"

                let today = dateFormatter.string(from: Date())
                
                let userInfo = UserInfo(userID: user.uid, userName: signUpContent.userName,
                    userEmail: signUpContent.email, userPhoto: signUpContent.userPhotoLink, userPhone: "", signInType: "email",
                    achievement: Achievement(experienceValue: 0, completionGoals: [], loginDates: [today]), certification: [])
                
                self.userManager.addData(user: userInfo)
                
                let friend = Friend(userID: user.uid, userName: signUpContent.userName,
                    friendList: [], blockadeList: [], applyList: [], deliveryList: [])
                
                self.friendManager.updateData(friend: friend)
                
                KeyToken().userID = user.uid

                self.view.window?.rootViewController?.viewWillAppear(true)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

            }
            
        }
        
    }
    
    @objc func uploadUserPhoto(sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
}

extension SignInViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let strongSelf = self else { return }

                switch result {

                case.success(let imageLink):
                    
                    strongSelf.userImageLink = "\(imageLink)"

                    strongSelf.signTableView.reloadData()
                    
                case .failure(let error):

                    print(error)
                    
                    HUD.flash(.labeledError(title: "上傳失敗！", subtitle: "請稍後再試"), delay: 0.5)

                }

            })

        }

        dismiss(animated: true)

    }
    
}
