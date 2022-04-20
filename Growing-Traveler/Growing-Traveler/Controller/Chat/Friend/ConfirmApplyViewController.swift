//
//  ConfirmApplyViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit

class ConfirmApplyViewController: UIViewController {
    
    var bothSides: BothSides?

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
        
        self.view.removeFromSuperview()
        
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
        
        print("TEST \(bothSides)")
        
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
        
        print("TEST \(bothSides)")
        
    }
}
