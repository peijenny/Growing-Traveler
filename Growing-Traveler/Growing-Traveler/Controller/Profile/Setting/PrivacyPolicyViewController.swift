//
//  PrivacyPolicyViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/9.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    var privacyTitle = String()
    
    var privacyURL = String()
    
    var comePage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = privacyTitle
        
        if privacyTitle == PrivacyPolicy.privacyPolicy.title {
            
            privacyURL = "https://www.privacypolicies.com/live/8f3c1eef-28a9-42ee-bad2-e8931d4da1b1"
            
        } else {
            
            privacyURL = "https://www.termsfeed.com/live/9aedd66f-c3b4-4bf7-adb6-4ec92f18bc92"
            
        }

        if let url = URL(string: privacyURL) {
            
            webView.load(URLRequest(url: url))
            
            webView.allowsBackForwardNavigationGestures = true
            
        }
        
        if comePage == "auth" {
            
            setNavigationItem()
            
        }

    }
    
    func setNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .stop, target: self, action: #selector(closePage))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func closePage(sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }

}

extension PrivacyPolicyViewController: WKNavigationDelegate {
    
    override func loadView() {
        
        webView = WKWebView()
        
        webView.navigationDelegate = self
        
        view = webView
        
    }
    
}
