//
//  NoteDetailViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/30.
//

import UIKit

class NoteDetailViewController: UIViewController {

    // MARK: - IBOutlet / Components
    @IBOutlet weak var noteCreateTimeLabel: UILabel!
    
    @IBOutlet weak var noteDatailTableView: UITableView! {
        
        didSet {
            
            noteDatailTableView.delegate = self
            
            noteDatailTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var noteDetailBackgroundView: UIView!
    
    // MARK: - Property
    var userManager = UserManager()
    
    var note: Note?

    var noteID: String?
    
    var noteUserID: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIStyle()
        
        registerTableViewCell()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchNoteData()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    // MARK: - Set UI
    func setUIStyle() {
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        noteDetailBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
    }
    
    func setNavigationItems() {
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage.asset(.edit), style: .plain, target: self, action: #selector(modifyNoteData)),
            UIBarButtonItem(
                image: UIImage.asset(.share), style: .plain, target: self, action: #selector(shareToFriendButton))
        ]
        
    }
    
    func registerTableViewCell() {
        
        noteDatailTableView.register(
            UINib(nibName: String(describing: ArticleDetailTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ArticleDetailTableViewCell.self))
        
    }
    
    // MARK: - Method
    func fetchNoteData() {
        
        userManager.fetchshareFriendNote(shareUserID: noteUserID ?? "", noteID: noteID ?? "") { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let note):
                
                self.note = note
                
                if KeyToken().userID == self.note?.userID {
                    
                    self.setNavigationItems()
                    
                }
                
                self.title = note.noteTitle
                
                let formatter = DateFormatter()
                
                formatter.dateFormat = "yyyy.MM.dd HH:mm"
                
                let createTime = Date(timeIntervalSince1970: note.createTime)
                
                self.noteCreateTimeLabel.text = formatter.string(from: createTime)
                
                self.noteDatailTableView.reloadData()
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    // MARK: - Target / IBAction
    @objc func shareToFriendButton(sender: UIButton) {
        
        let viewController = ShareToFriendViewController()
        
        viewController.shareType = SendType.noteID.title
        
        viewController.shareID = note?.noteID
        
        let navController = UINavigationController(rootViewController: viewController)
        
        if #available(iOS 15.0, *) {
            
            guard let sheetPresentationController = navController.sheetPresentationController else { return }
            
            sheetPresentationController.detents = [.medium()]
            
        } else {

            navController.modalPresentationStyle = .fullScreen
        }
        
        present(navController, animated: true)
        
    }
    
    @objc func modifyNoteData(sender: UIButton) {
        
        guard let viewController = UIStoryboard.note.instantiateViewController(
            withIdentifier: String(describing: PublishNoteViewController.self)
        ) as? PublishNoteViewController else { return }
        
        viewController.modifyNote = note
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

// MARK: - TableView delegate / dataSource
extension NoteDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return note?.content.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ArticleDetailTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? ArticleDetailTableViewCell else { return cell }
        
        cell.selectionStyle = .none
        
        if let content = note?.content {
            
            cell.setArticleContent(content: content[indexPath.row], isNote: true)
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ArticleDetailTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? ArticleDetailTableViewCell else { return }
        
        if note?.content[indexPath.row].contentType ?? "" == SendType.image.title {
            
            cell.contentImageView.loadImage(note?.content[indexPath.row].contentText)
            
            cell.contentImageView.showPhoto(imageView: cell.contentImageView)
            
        }
        
    }
    
}
