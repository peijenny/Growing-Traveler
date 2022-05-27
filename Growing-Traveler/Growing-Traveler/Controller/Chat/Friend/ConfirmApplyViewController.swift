//
//  ConfirmApplyViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit

class ConfirmApplyViewController: UIViewController {
    
    // MARK: - IBOutlet / Components
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var agreeButton: UIButton!
    
    // MARK: - Property
    var friendManager = FriendManager()
    
    var getConfirmStatus: ((_ isConfirm: Bool) -> Void)?
    
    var bothSides: BothSides?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        agreeButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)

    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    // MARK: - Target / IBAction
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
                
                break
                
            }
            
        }
        
        for index in 0..<bothSides.owner.applyList.count {
            
            if bothSides.other.deliveryList[index] == bothSides.owner.userID {
                
                bothSides.other.deliveryList.remove(at: index)
                
                break
                
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
                
                break
                
            }
            
        }
        
        for index in 0..<bothSides.owner.applyList.count {
            
            if bothSides.other.deliveryList[index] == bothSides.owner.userID {
                
                bothSides.other.deliveryList.remove(at: index)
                
                bothSides.other.friendList.append(bothSides.owner.userID)
                
                break
                
            }
            
        }
        
        friendManager.addFriendData(bothSides: bothSides, confirmType: ConfirmType.agree.title)

        self.navigationController?.isNavigationBarHidden = false

        self.view.removeFromSuperview()

        getConfirmStatus?(true)

    }
    
}
