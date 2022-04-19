//
//  ChatViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/18.
//

import UIKit

class ChatViewController: UIViewController {
    
    var chatRoomManager = ChatRoomManager()
    
    var friendID: String? {
        
        didSet {
            
            fetchData()
            
        }
        
    }
    
    var chatMessage: Chat?

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
    
    func fetchData() {
        
        chatRoomManager.fetchData(friendID: friendID ?? "", completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let chatMessage):
                
                strongSelf.chatMessage = chatMessage
                
            case .failure(let error):
                
                print(error)
                
            }
            
        })
        
    }
    
}
