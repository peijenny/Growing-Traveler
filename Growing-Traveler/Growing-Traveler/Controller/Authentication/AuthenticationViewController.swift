//
//  AuthenticationViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/25.
//

import UIKit
import AuthenticationServices

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var signInWithAppleButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupProviderLoginView()
        
    }
    
    func setupProviderLoginView() {

        let authorizationButton = ASAuthorizationAppleIDButton()
        
        authorizationButton.addTarget(
            self, action: #selector(handleAuthorizationAppleIDButtonPress),
            for: .touchUpInside)
        
        self.signInWithAppleButtonView.addSubview(authorizationButton)
        
    }
    
    @objc func handleAuthorizationAppleIDButtonPress(sender: UIButton) {

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(
            authorizationRequests: [request])
        
        authorizationController.delegate = self
        
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()

    }
    
}

extension AuthenticationViewController: ASAuthorizationControllerDelegate {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        if let window = self.view.window {
            
            return window
            
        } else {
            
            return ASPresentationAnchor()
            
        }
        
    }
    
}

extension AuthenticationViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system
            let userIdentifier = appleIDCredential.user
            
            let fullName = appleIDCredential.fullName
            
            let email = appleIDCredential.email

        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud keychain credential
            let userName = passwordCredential.user
            
            let password = passwordCredential.password
            
        default:
            
            break
            
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        // Handle error
        
    }
    
}
