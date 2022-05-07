//
//  ConfirmApplyViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit

enum ConfirmType {
    
    case agree
    
    case refuse
    
    case apply
    
    var title: String {
        
        switch self {
            
        case .agree: return "同意"
            
        case .refuse: return "取消"
            
        case .apply: return "申請"
            
        }
        
    }
    
}

class ConfirmApplyViewController: UIViewController {
    
    var bothSides: BothSides?
    
    var friendManager = FriendManager()
    
    var getConfirmStatus: ((_ isConfirm: Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.view.removeFromSuperview()
        
        getConfirmStatus?(false)
        
    }
    
    @IBAction func refuseApplyButton(_ sender: UIButton) {
        
        guard var bothSides = bothSides else { return }
        
        for index in 0..<bothSides.owner.applyList.count {
            
            if bothSides.owner.applyList[index] == bothSides.other.userID {
                
                bothSides.owner.applyList.remove(at: index)
                
            }
            
            if bothSides.other.deliveryList[index] == bothSides.owner.userID {
                
                bothSides.other.deliveryList.remove(at: index)
                
            }
            
        }

        friendManager.addFriendData(bothSides: bothSides, confirmType: ConfirmType.refuse.title)
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.view.removeFromSuperview()
        
        getConfirmStatus?(true)
        
    }
    
    @IBAction func agreeApplyButton(_ sender: UIButton) {
        
        guard var bothSides = bothSides else { return }
        
        for index in 0..<bothSides.owner.applyList.count {
            
            if bothSides.owner.applyList[index] == bothSides.other.userID {
                
                bothSides.owner.applyList.remove(at: index)
                
                bothSides.owner.friendList.append(bothSides.other.userID)
                
            }
            
            if bothSides.other.deliveryList[index] == bothSides.owner.userID {
                
                bothSides.other.deliveryList.remove(at: index)
                
                bothSides.other.friendList.append(bothSides.owner.userID)
                
            }
            
        }
        
        friendManager.addFriendData(bothSides: bothSides, confirmType: ConfirmType.agree.title)
        
        self.view.removeFromSuperview()
        
        getConfirmStatus?(true)

    }
}
