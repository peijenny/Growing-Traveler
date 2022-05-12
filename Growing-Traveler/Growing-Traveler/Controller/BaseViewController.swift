//
//  BaseViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/11.
//

import UIKit
import IQKeyboardManagerSwift

// MARK: - BaseVC handle keyboard event
class BaseViewController: UIViewController {
    
    static var identifier: String { return String(describing: self) }
    
    var isHideNavigationBar: Bool { return false }

    var isEnableResignOnTouchOutside: Bool { return true }

    var isEnableIQKeyboard: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(0.9)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isHideNavigationBar {
            
            navigationController?.setNavigationBarHidden(true, animated: true)
            
        }
        
        IQKeyboardManager.shared.enable = (!isEnableIQKeyboard) ? false : true
        
        IQKeyboardManager.shared.shouldResignOnTouchOutside = (!isEnableResignOnTouchOutside) ? false : true
        
        self.setNeedsStatusBarAppearanceUpdate()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isHideNavigationBar {
            
            navigationController?.setNavigationBarHidden(false, animated: true)
            
        }
        
        IQKeyboardManager.shared.enable = (!isEnableIQKeyboard) ? true : false
        
        IQKeyboardManager.shared.shouldResignOnTouchOutside = (!isEnableResignOnTouchOutside) ? true : false

    }

    // when click view any where, keyboard hide
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)

    }

}

extension BaseViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}
