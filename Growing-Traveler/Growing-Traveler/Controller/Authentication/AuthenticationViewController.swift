//
//  AuthenticationViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/25.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import PKHUD

enum SignType {
    
    case signIn
    
    case signUp
    
    var title: String {
        
        switch self {
            
        case .signIn: return "登入"
            
        case .signUp: return "註冊"
            
        }
        
    }
    
}

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var signInWithAppleButtonView: UIView!
    
    fileprivate var currentNonce: String?
    
    var friendManager = FriendManager()
    
    var userManager = UserManager()
    
    var errorManager = ErrorManager()
    
    var users: [UserInfo] = []

    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserData()
        
        setupProviderLoginView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signInButton.layer.cornerRadius = 5
        
        signUpButton.layer.cornerRadius = 5
        
    }
    
    func fetchUserData() {
        
        friendManager.listenFriendInfoData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let usersInfo):
                
                strongSelf.users = usersInfo
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func setupProviderLoginView() {

        let authorizationButton = ASAuthorizationAppleIDButton()
        
        authorizationButton.addTarget(
            self, action: #selector(handleAuthorizationAppleIDButtonPress),
            for: .touchUpInside)
        
        authorizationButton.frame = signInWithAppleButtonView.bounds
        
        self.signInWithAppleButtonView.addSubview(authorizationButton)
        
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        
        request.nonce = sha256(nonce)
        
        currentNonce = nonce
        
        return request
    }
    
    func performSignIn() {
        
        let request = createAppleIDRequest()
        
        let authorizationController = ASAuthorizationController(
            authorizationRequests: [request])
        
        authorizationController.delegate = self
        
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
        
    }
    
    @objc func handleAuthorizationAppleIDButtonPress(sender: UIButton) {

        performSignIn()
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func signInWithEmail(_ sender: UIButton) {
        
        presentToSignPage(signType: SignType.signIn.title)
        
    }
    
    @IBAction func signUpWithEmail(_ sender: UIButton) {
        
        presentToSignPage(signType: SignType.signUp.title)
        
    }
    
    func presentToSignPage(signType: String) {
        
        guard let viewController = UIStoryboard.auth.instantiateViewController(
                withIdentifier: String(describing: SignInViewController.self)
                ) as? SignInViewController else { return }
        
        viewController.modalPresentationStyle = .fullScreen
        
        viewController.signType = signType

        present(viewController, animated: true, completion: nil)
        
    }
    
}

extension AuthenticationViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            HUD.show(.labeledProgress(title: "登入中...", subtitle: ""))
            
            let givenName = appleIDCredential.fullName?.givenName ?? ""
            
            let familyName = appleIDCredential.fullName?.familyName ?? ""
            
            guard let nonce = currentNonce else {
                
                print("Invalid state: A login callback was received, but no login request was sent.")
                
                return
                
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                
                print("Unable to fetch identity token.")
                
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                
                return
            }
            
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authDataResult, error in

                if let error = error as? NSError {
                    
                    print(error)
                    
                    guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                        
                        print("登入錯誤，於 firebase 無法找到配對的帳號！")
                        
                        return
                        
                    }
                    
                    self.errorManager.handleAuthError(errorCode: errorCode)

                }
                
                if let user = authDataResult?.user {
                    
                    HUD.flash(.labeledSuccess(title: "登入成功！", subtitle: nil))
                    
                    var photo = ""
                    
                    if user.photoURL != nil {
                        
                        photo = "\(String(describing: user.photoURL))"
                        
                    }
                    
                    userID = "\(Auth.auth().currentUser?.uid ?? "")"
                    
                    if self.users.filter({ $0.userID == user.uid }).count == 0 {
                        
                        let dateFormatter = DateFormatter()

                        dateFormatter.dateFormat = "yyyy.MM.dd"

                        let today = dateFormatter.string(from: Date())
                        
                        let userInfo = UserInfo(
                            userID: user.uid,
                            userName: "\(givenName) \(familyName)",
                            userEmail: user.email ?? "",
                            userPhoto: "\(photo)",
                            userPhone: user.phoneNumber ?? "",
                            signInType: "appleID",
                            achievement: Achievement(
                                experienceValue: 0, completionGoals: [], loginDates: [today]),
                            certification: []
                        )
                        
                        self.userManager.addData(user: userInfo)
                        
                        let friend = Friend(
                            userID: user.uid,
                            userName: "\(givenName) \(familyName)",
                            friendList: [], blockadeList: [],
                            applyList: [], deliveryList: []
                        )
                        
                        self.friendManager.addData(friend: friend)
                        
                    }
                    
                    self.view.window?.rootViewController?.viewWillAppear(true)
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
}

extension AuthenticationViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
        
    }
}

private func randomNonceString(length: Int = 32) -> String {
    
    precondition(length > 0)
    
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    
    var result = ""
    
    var remainingLength = length
    
    while remainingLength > 0 {
        
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            
            var random: UInt8 = 0
            
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            
            if errorCode != errSecSuccess {
                
                print(
                    
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    
                )
                
            }
            
            return random
            
        }
        
        randoms.forEach { random in
            
            if remainingLength == 0 {
                
                return
                
            }
            
            if random < charset.count {
                
                result.append(charset[Int(random)])
                
                remainingLength -= 1
                
            }
            
        }
        
    }
    
    return result
}

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
    
    let inputData = Data(input.utf8)
    
    let hashedData = SHA256.hash(data: inputData)
    
    let hashString = hashedData.compactMap {
        
        String(format: "%02x", $0)
        
    }.joined()
    
    return hashString
    
}
