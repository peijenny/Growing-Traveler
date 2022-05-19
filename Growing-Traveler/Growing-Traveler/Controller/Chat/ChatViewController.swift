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
            
            title = "\(chatMessage?.friendName ?? "")"
            
            chatTableView.reloadData()
            
            if let messageCount = chatMessage?.messageContent.count {

                if chatMessage?.messageContent.count != 0 {

                    let indexPath = IndexPath(row: messageCount - 1, section: 0)

                    chatTableView.scrollToRow(at: indexPath, at: .top, animated: false)

                }

            }
            
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
        
        if deleteAccount {
            
            friendStatusLabel.text = "此帳號已刪除，無法發送訊息！"
            
            friendStatusLabel.isHidden = false
            
        }
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        chatTableView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightGary.hexText)
        
        friendStatusLabel.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        friendStatusLabel.textColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        uploadImageButton.tintColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        sendMessageButton.tintColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
    }

    func setNavigationItems() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.user), style: .plain, target: self, action: #selector(friendInfoButton))

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
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isBlock {
            
            friendStatusLabel.text = "此帳號已封鎖，無法發送訊息！"
            
            friendStatusLabel.isHidden = false
            
        }
        
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
                
            case .failure(let error):

                print(error)

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
                
                for index in 0..<chatMessage.messageContent.count {
                    
                    if chatMessage.messageContent[index].sendType == SendType.noteID.title {
                        
                        strongSelf.fetchshareNoteData(
                            shareUserID: chatMessage.messageContent[index].sendUserID,
                            noteID: chatMessage.messageContent[index].sendMessage)
                        
                    } else if chatMessage.messageContent[index].sendType == SendType.articleID.title {
                        
                        strongSelf.fetchShareArticleData(articleID: chatMessage.messageContent[index].sendMessage)
                        
                    }
                    
                }
                
            case .failure(let error):

                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

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
                
            case .failure(let error):

                print(error)
                
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
                
                print("TEST \(forumArticle)")
                
                strongSelf.forumArticles.append(forumArticle)
                
                strongSelf.chatTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
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
        
        if chatMessage?.messageContent[indexPath.row].sendType == SendType.image.title ||
            chatMessage?.messageContent[indexPath.row].sendType == SendType.string.title {
            
            if chatMessage?.messageContent[indexPath.row].sendUserID != KeyToken().userID {
                
                cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: ReceiveMessageTableViewCell.self), for: indexPath)
                
                guard let cell = cell as? ReceiveMessageTableViewCell else { return cell }
                
                if let receiveMessage = chatMessage?.messageContent[indexPath.row] {
                    
                    cell.showMessage(receiveMessage: receiveMessage, friendPhoto: friendInfo?.userPhoto)
                    
                }
                
            } else {
                
                cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: SendMessageTableViewCell.self), for: indexPath)
                
                guard let cell = cell as? SendMessageTableViewCell else { return cell }
                
                if let sendMessage = chatMessage?.messageContent[indexPath.row] {
                    
                    cell.showMessage(sendMessage: sendMessage)
                    
                }
                
            }
            
        } else {
            
            if chatMessage?.messageContent[indexPath.row].sendUserID != KeyToken().userID {
                
                cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: ShareReceiveTableViewCell.self), for: indexPath)
                
                guard let cell = cell as? ShareReceiveTableViewCell else { return cell }
                
                let note = notes.filter({ $0.noteID == chatMessage?.messageContent[indexPath.row].sendMessage })
                
                let article = forumArticles.filter({ $0.id == chatMessage?.messageContent[indexPath.row].sendMessage })
                
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

                case .failure(let error):

                    print(error)
                    
                    HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)

                }

            })

        }

        dismiss(animated: true)

    }
    
}
