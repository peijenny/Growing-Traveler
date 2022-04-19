//
//  ChatViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/18.
//

import UIKit

class ChatViewController: BaseViewController {
    
    @IBOutlet weak var chatTableView: UITableView! {
        
        didSet {
            
            chatTableView.delegate = self
            
            chatTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var snedInputTextView: UITextView!
    
    var chatRoomManager = ChatRoomManager()
    
    var friendID: String? {
        
        didSet {
            
            fetchData()
            
        }
        
    }
    
    var chatMessage: Chat? {
        
        didSet {
            
            chatTableView.reloadData()
            
            if let messageCount = chatMessage?.messageContent.count {
                
                let indexPath = IndexPath(row: messageCount - 1, section: 0)
                
                chatTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.register(
            UINib(nibName: String(describing: ReceiveMessageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ReceiveMessageTableViewCell.self)
        )
        
        chatTableView.register(
            UINib(nibName: String(describing: SendMessageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SendMessageTableViewCell.self)
        )
        
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
    
    @IBAction func sendInputMessageButton(_ sender: UIButton) {
        
        guard let sendInput = snedInputTextView.text else { return }
        
        var sendType = String()
        
        if sendInput != "" {
            
            if sendInput.range(of: "https://i.imgur.com") != nil {

                sendType = "image"

            } else {

                sendType = "string"

            }
            
            let messageContent = MessageContent(
                createTime: TimeInterval(Int(Date().timeIntervalSince1970)),
                sendMessage: sendInput,
                sendType: sendType,
                sendUserID: userID
            )
            
            chatMessage?.messageContent.append(messageContent)
            
            guard let chatMessage = chatMessage else { return }
            
            chatRoomManager.addData(chat: chatMessage)
            
            snedInputTextView.text = nil
            
        }
        
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatMessage?.messageContent.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if chatMessage?.messageContent[indexPath.row].sendUserID == friendID {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ReceiveMessageTableViewCell.self),
                for: indexPath
            )
            
            guard let cell = cell as? ReceiveMessageTableViewCell else { return cell }
            
            if let receiveMessage = chatMessage?.messageContent[indexPath.row] {
                
                cell.showMessage(receiveMessage: receiveMessage)
                
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SendMessageTableViewCell.self),
                for: indexPath
            )
            
            guard let cell = cell as? SendMessageTableViewCell else { return cell }
            
            if let sendMessage = chatMessage?.messageContent[indexPath.row] {
                
                cell.showMessage(sendMessage: sendMessage)
                
            }

            return cell
            
        }
        
    }
    
}
