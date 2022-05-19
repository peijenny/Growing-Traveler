//
//  ChatViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/18.
//

import UIKit
import PKHUD

class ChatViewController: BaseViewController {
    
    @IBOutlet weak var chatTableView: UITableView! {
        
        didSet {
            
            chatTableView.delegate = self
            
            chatTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var snedInputTextView: UITextView!

    @IBOutlet weak var friendStatusLabel: UILabel!
    
    @IBOutlet weak var uploadImageButton: UIButton!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var displayImageView = UIImageView()
    
    var forumArticleManager = ForumArticleManager()
    
    var chatRoomManager = ChatRoomManager()
    
    var friendManager = FriendManager()
    
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
    
    var chatMessage: Chat? {
        
        didSet {
            
            scrollChatTableViewRow(chatMessage: chatMessage)
            
        }
        
    }
    
    var userName = String()
    
    var isBlock = Bool()
    
    var deleteAccount = Bool()
    
    var notes: [Note] = []
    
    var otherFriendList: Friend?
    
    var forumArticles: [ForumArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()
        
        registerTableViewCell()
        
        setUIStyle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if deleteAccount {
            
            friendStatusLabel.text = "此帳號已刪除，無法發送訊息！"
            
            friendStatusLabel.isHidden = false
            
        }

        if isBlock {
            
            friendStatusLabel.text = "此帳號已封鎖，無法發送訊息！"
            
            friendStatusLabel.isHidden = false
            
        }
        
        fetchFriendInfoData()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func scrollChatTableViewRow(chatMessage: Chat?) {
        
        title = "\(chatMessage?.friendName ?? "")"
        
        chatTableView.reloadData()
        
        if let messageCount = chatMessage?.messageContent.count {

            if chatMessage?.messageContent.count != 0 {

                let indexPath = IndexPath(row: messageCount - 1, section: 0)

                chatTableView.scrollToRow(at: indexPath, at: .top, animated: false)

            }

        }
        
    }

    func setNavigationItems() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.user), style: .plain, target: self, action: #selector(friendInfoButton))

    }
    
    func registerTableViewCell() {
        
        chatTableView.register(
            UINib(nibName: String(describing: ReceiveMessageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ReceiveMessageTableViewCell.self))
        
        chatTableView.register(
            UINib(nibName: String(describing: SendMessageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SendMessageTableViewCell.self))
        
        chatTableView.register(
            UINib(nibName: String(describing: ShareReceiveTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ShareReceiveTableViewCell.self))
        
        chatTableView.register(
            UINib(nibName: String(describing: ShareSendTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ShareSendTableViewCell.self))
        
    }
    
    func setUIStyle() {
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        chatTableView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
        friendStatusLabel.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        friendStatusLabel.textColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        uploadImageButton.tintColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        sendMessageButton.tintColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
    }
    
    @objc func friendInfoButton(sender: UIButton) {
        
        guard let viewController = UIStoryboard.chat.instantiateViewController(
            withIdentifier: String(describing: UserInfoViewController.self)
        ) as? UserInfoViewController else { return }
        
        viewController.deleteAccount = false
        
        viewController.selectUserID = friendID
        
        viewController.reportContentType = ReportContentType.chat.title
        
        viewController.blockContentType = BlockContentType.chat.title
        
        viewController.getFriendStatus = { [weak self] isBlock in
            
            guard let strongSelf = self else { return }
            
            if isBlock {
                
                strongSelf.friendStatusLabel.text = "此帳號已封鎖，無法發送訊息！"
                
                strongSelf.friendStatusLabel.isHidden = false
                
                strongSelf.navigationController?.popViewController(animated: true)
                
            }
            
        }
        
        self.view.addSubview(viewController.view)

        self.addChild(viewController)
        
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

            case .failure:
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

            }

        }
        
    }
    
    func fetchOtherFriendListData() {
        
        friendManager.fetchFriendListData(fetchUserID: friendID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {

            case .success(let friendList):

                strongSelf.otherFriendList = friendList
                
                if !friendList.blockadeList.filter({ $0 == KeyToken().userID }).isEmpty {
                    
                    strongSelf.friendStatusLabel.text = "此好友已離開聊天室，無法發送訊息！"

                    strongSelf.friendStatusLabel.isHidden = false
                    
                }
                
            case .failure:

                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }

        }
        
    }
    
    func fetchChatRoomData() {

        chatRoomManager.fetchData(friendID: friendID) { [weak self] result in

            guard let strongSelf = self else { return }

            switch result {

            case .success(let chatMessage):

                strongSelf.chatMessage = chatMessage
                
                strongSelf.handleChatMessage(chatMessage: chatMessage)
                
            case .failure:

                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

            }

        }

    }
    
    func handleChatMessage(chatMessage: Chat) {
        
        for index in 0..<chatMessage.messageContent.count {
            
            if chatMessage.messageContent[index].sendType == SendType.noteID.title {
                
                fetchshareNoteData(
                    shareUserID: chatMessage.messageContent[index].sendUserID,
                    noteID: chatMessage.messageContent[index].sendMessage)
                
            } else if chatMessage.messageContent[index].sendType == SendType.articleID.title {
                
                fetchShareArticleData(articleID: chatMessage.messageContent[index].sendMessage)
                
            }
            
        }
        
    }
    
    func fetchshareNoteData(shareUserID: String, noteID: String) {
        
        userManager.fetchshareNoteData(shareUserID: shareUserID, noteID: noteID) { [weak self] result in
            
            guard let strongSelf = self else { return }

            switch result {

            case .success(let note):
                
                let note = note
                
                strongSelf.notes.append(note)
                
                strongSelf.chatTableView.reloadData()
                
            case .failure:

                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

            }
            
        }
        
    }
    
    func fetchShareArticleData(articleID: String) {
        
        forumArticleManager.fetchForumArticleData(articleID: articleID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let forumArticle):
                
                let forumArticle = forumArticle
                
                strongSelf.forumArticles.append(forumArticle)
                
                strongSelf.chatTableView.reloadData()
                
            case .failure:
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
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

                sendType = SendType.image.title

            } else {

                sendType = SendType.string.title

            }
            
            let createTime = TimeInterval(Int(Date().timeIntervalSince1970))
            
            let messageContent = MessageContent(
                createTime: createTime, sendMessage: inputContent, sendType: sendType, sendUserID: KeyToken().userID)
            
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatMessage?.messageContent.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = UITableViewCell()
        
        guard let messageContent = chatMessage?.messageContent[indexPath.row] else { return cell }
        
        if messageContent.sendType == SendType.image.title || messageContent.sendType == SendType.string.title {
            
            if messageContent.sendUserID != KeyToken().userID {
                
                cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: ReceiveMessageTableViewCell.self), for: indexPath)
                
                guard let cell = cell as? ReceiveMessageTableViewCell else { return cell }
                
                cell.showMessage(receiveMessage: messageContent, friendPhoto: friendInfo?.userPhoto)
                
            } else {
                
                cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: SendMessageTableViewCell.self), for: indexPath)
                
                guard let cell = cell as? SendMessageTableViewCell else { return cell }
                
                cell.showMessage(sendMessage: messageContent)
                
            }
            
        } else {
            
            if messageContent.sendUserID != KeyToken().userID {
                
                cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: ShareReceiveTableViewCell.self), for: indexPath)
                
                guard let cell = cell as? ShareReceiveTableViewCell else { return cell }
                
                let note = notes.filter({ $0.noteID == messageContent.sendMessage })
                
                let article = forumArticles.filter({ $0.id == messageContent.sendMessage })
                
                if !note.isEmpty {
                    
                    cell.showShareNote(note: note[0], userPhoto: friendInfo?.userPhoto)
                    
                }
                
                if !article.isEmpty {
                    
                    cell.showShareArticle(forumArticle: article[0], userPhoto: friendInfo?.userPhoto)

                }
                
                cell.setCreateTime(receiveCreateTime:
                    chatMessage?.messageContent[indexPath.row].createTime ?? TimeInterval())
                
            } else {

                cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: ShareSendTableViewCell.self), for: indexPath)
                
                guard let cell = cell as? ShareSendTableViewCell else { return cell }
                
                let note = notes.filter({ $0.noteID == chatMessage?.messageContent[indexPath.row].sendMessage })
                
                let article = forumArticles.filter({ $0.id == chatMessage?.messageContent[indexPath.row].sendMessage })
                
                cell.setCreateTime(sendCreateTime:
                    chatMessage?.messageContent[indexPath.row].createTime ?? TimeInterval())
                
                if !note.isEmpty {
                    
                    cell.showShareNote(note: note[0])
                    
                }
                
                if !article.isEmpty {
                    
                    cell.showShareArticle(forumArticle: article[0])
                }
                
            }
            
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let sendMessage = chatMessage?.messageContent[indexPath.row] else { return }
        
        if sendMessage.sendType == SendType.image.title {
            
            displayImageView.loadImage(sendMessage.sendMessage)
            
            displayImageView.showPhoto(imageView: displayImageView)
            
        }
        
        if sendMessage.sendType == SendType.noteID.title {
            
            guard let viewController = UIStoryboard.note.instantiateViewController(
                withIdentifier: String(describing: NoteDetailViewController.self)
            ) as? NoteDetailViewController else { return }
            
            viewController.noteID = sendMessage.sendMessage
            
            viewController.noteUserID = sendMessage.sendUserID
            
            navigationController?.pushViewController(viewController, animated: true)
            
        }
        
        if sendMessage.sendType == SendType.articleID.title {
            
            let viewController = ArticleDetailViewController()
            
            let forumArticle = forumArticles.filter({ $0.id == sendMessage.sendMessage })
            
            if forumArticle.isEmpty {
                
                HUD.flash(.label("該文章已被刪除！"), delay: 0.5)
                
            } else {
                
                viewController.forumArticle = forumArticle[0]
                
                navigationController?.pushViewController(viewController, animated: true)
                
            }
            
        }
        
    }
    
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let strongSelf = self else { return }

                switch result {

                case.success(let imageLink):

                    strongSelf.addMessageData(inputContent: imageLink)

                case .failure:

                    HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

                }

            })

        }

        dismiss(animated: true)

    }
    
}
