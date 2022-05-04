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
    
    var userManager = UserManager()
    
    var friendInfo: UserInfo? {
        
        didSet {
            
            snedInputTextView.isUserInteractionEnabled = true
            
            snedInputTextView.text = ""
            
            snedInputTextView.textColor = UIColor.black
            
        }
        
    }
    
    var friendID = String() {
        
        didSet {
            
            fetchChatRoomData()
            
        }
        
    }
    
    var userName = String()
    
    var chatMessage: Chat? {
        
        didSet {
            
            self.title = "\(chatMessage?.friendName ?? "")"
            
            chatTableView.reloadData()
            
            if let messageCount = chatMessage?.messageContent.count {
                
                if chatMessage?.messageContent.count != 0 {
                    
                    let indexPath = IndexPath(row: messageCount - 1, section: 0)
                    
                    chatTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                    
                }
                
            }
            
        }
        
    }
    
    var myImageView = UIImageView()
    
    var isBlock = Bool()
    
    var deleteAccount = Bool()

    @IBOutlet weak var friendStatusLabel: UILabel!
    
    var friendManager = FriendManager()
    
    var otherFriendList: Friend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()
        
        chatTableView.register(
            UINib(nibName: String(describing: ReceiveMessageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ReceiveMessageTableViewCell.self)
        )
        
        chatTableView.register(
            UINib(nibName: String(describing: SendMessageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SendMessageTableViewCell.self)
        )
        
        if deleteAccount {
            
            friendStatusLabel.text = "此帳號已刪除，無法發送訊息！"
            
            friendStatusLabel.isHidden = false
            
        }
        
    }

    func setNavigationItems() {

//        navigationItem.rightBarButtonItems = [
//            UIBarButtonItem(image: UIImage.asset(.telephoneCall),
//                style: .plain, target: self, action: #selector(callAudioPhone)),
//            UIBarButtonItem(image: UIImage.asset(.videoCamera),
//                style: .plain, target: self, action: #selector(callVideoPhone))
//        ]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .stop, target: self, action: #selector(blockadeFriend))

    }
    
    @objc func blockadeFriend() {
        
        // 彈跳出 User 視窗
        guard let viewController = UIStoryboard
            .chat
            .instantiateViewController(
            withIdentifier: String(describing: UserInfoViewController.self)
            ) as? UserInfoViewController else { return }
        
        viewController.deleteAccount = false
        
        viewController.selectUserID = friendID
        
        viewController.getFriendStatus = { [weak self] isBlock in
            
            guard let strongSelf = self else { return }
            
            if isBlock {
                
                strongSelf.friendStatusLabel.text = "此帳號已封鎖，無法發送訊息！"
                
                strongSelf.friendStatusLabel.isHidden = false
                
            }
            
        }
        
        self.view.addSubview(viewController.view)

        self.addChild(viewController)
        
    }

    @objc func callAudioPhone(sender: UIButton) {

        guard let phoneEmail = friendInfo?.userEmail else { return }

        // 語音通話
        if let facetimeURL: NSURL = NSURL(string: "facetime-audio://\(phoneEmail)") {

            let application: UIApplication = UIApplication.shared

            if application.canOpenURL(facetimeURL as URL) {

                application.open(facetimeURL as URL)

            }

        }

    }

    @objc func callVideoPhone(sender: UIButton) {

        guard let phoneEmail = friendInfo?.userEmail else { return }

        // 視訊通話
        if let facetimeURL: NSURL = NSURL(string: "facetime://\(phoneEmail)") {

            let application: UIApplication = UIApplication.shared

            if application.canOpenURL(facetimeURL as URL) {

                application.open(facetimeURL as URL)

            }

        }

    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFriendInfoData()
        
    }
    
    func fetchFriendInfoData() {
        
        userManager.fetchData(fetchUserID: friendID) { [weak self] result in
            
            guard let strongSelf = self else { return }

            switch result {

            case .success(let friendInfo):

                strongSelf.friendInfo = friendInfo
                
                if strongSelf.friendInfo != nil {
                    
                    strongSelf.fetchOtherFriendListData()
                    
                }
                
                strongSelf.chatTableView.reloadData()

            case .failure(let error):

                print(error)

            }

        }
        
    }
    
    func fetchOtherFriendListData() {
        
        friendManager.fetchFriendListData(fetchUserID: friendID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {

            case .success(let friendList):

                strongSelf.otherFriendList = friendList
                
            case .failure(let error):

                print(error)

            }

        }
    }
    
    func fetchChatRoomData() {

        chatRoomManager.fetchData(friendID: friendID) { [weak self] result in

            guard let strongSelf = self else { return }

            switch result {

            case .success(let chatMessage):

                strongSelf.chatMessage = chatMessage
                
            case .failure(let error):

                print(error)

            }

        }

    }
    
    @IBAction func sendInputMessageButton(_ sender: UIButton) {
        
        guard let sendInput = snedInputTextView.text else { return }
        
        addMessageData(inputContent: sendInput)
        
    }
    
    func addMessageData(inputContent: String) {
        
        var sendType = String()
        
        if inputContent != "" {
            
            if inputContent.range(of: "https://i.imgur.com") != nil {

                sendType = "image"

            } else {

                sendType = "string"

            }
            
            let messageContent = MessageContent(
                createTime: TimeInterval(Int(Date().timeIntervalSince1970)),
                sendMessage: inputContent,
                sendType: sendType,
                sendUserID: userID
            )
            
            chatMessage?.messageContent.append(messageContent)
            
            guard let chatMessage = chatMessage else { return }

            chatRoomManager.addData(userName: userName, chat: chatMessage)

            snedInputTextView.text = nil
            
        }
        
    }
    
    @IBAction func sendImageButton(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        present(picker, animated: true)
        
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
        
        if chatMessage?.messageContent[indexPath.row].sendUserID != userID {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ReceiveMessageTableViewCell.self),
                for: indexPath
            )
            
            guard let cell = cell as? ReceiveMessageTableViewCell else { return cell }

            if let blockadeList = otherFriendList?.blockadeList {
                
                if blockadeList.filter({ $0 == userID }).count != 0 {
                    
                    friendStatusLabel.text = "此好友已離開聊天室，無法發送訊息！"
                    
                    friendStatusLabel.isHidden = false
                    
                }
                
            }
            
            if isBlock {
                
                friendStatusLabel.text = "此帳號已封鎖，無法發送訊息！"
                
                friendStatusLabel.isHidden = false
                
            }
            
            if let receiveMessage = chatMessage?.messageContent[indexPath.row] {
                
                cell.showMessage(receiveMessage: receiveMessage, friendPhoto: friendInfo?.userPhoto)
                
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let sendMessage = chatMessage?.messageContent[indexPath.row] else { return }
        
        if sendMessage.sendType == "image" {
            
            myImageView.loadImage(sendMessage.sendMessage)
            
            myImageView.showPhoto(imageView: myImageView)
            
        }
        
    }
    
}

extension ChatViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let strongSelf = self else { return }

                switch result {

                case.success(let imageLink):

                    strongSelf.addMessageData(inputContent: imageLink)

                case .failure(let error):

                    print(error)

                }

            })

        }

        dismiss(animated: true)

    }
    
}
