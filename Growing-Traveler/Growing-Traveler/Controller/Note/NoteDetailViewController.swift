//
//  NoteDetailViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/30.
//

import UIKit
import PKHUD

class NoteDetailViewController: UIViewController {

    @IBOutlet weak var noteCreateTimeLabel: UILabel!
    
    @IBOutlet weak var noteDatailTableView: UITableView! {
        
        didSet {
            
            noteDatailTableView.delegate = self
            
            noteDatailTableView.dataSource = self
            
        }
        
    }
    
    var userManager = UserManager()
    
    var note: Note?

    var noteID: String?
    
    var noteUserID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        noteDatailTableView.register(
            UINib(nibName: String(describing: ArticleDetailTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ArticleDetailTableViewCell.self))
        
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
    
    func fetchNoteData() {
        
        userManager.fetchshareNoteData(shareUserID: noteUserID ?? "", noteID: noteID ?? "") { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let note):
                
                strongSelf.note = note
                
                if userID == strongSelf.note?.userID {
                    
                    strongSelf.setNavigationItems()
                    
                }
                
                strongSelf.title = note.noteTitle
                
                let formatter = DateFormatter()
                
                formatter.dateFormat = "yyyy.MM.dd HH:mm"
                
                let createTime = Date(timeIntervalSince1970: note.createTime)
                
                strongSelf.noteCreateTimeLabel.text = formatter.string(from: createTime)
                
                strongSelf.noteDatailTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func setNavigationItems() {
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage.asset(.edit), style: .plain, target: self, action: #selector(modifyNoteData)),
            UIBarButtonItem(
                image: UIImage.asset(.share), style: .plain, target: self, action: #selector(shareToFriendButton))
        ]
        
    }
    
    @objc func shareToFriendButton(sender: UIButton) {
        
        let viewController = ShareToFriendViewController()
        
        viewController.shareType = SendType.noteID.title
        
        viewController.shareID = note?.noteID
        
        let navController = UINavigationController(rootViewController: viewController)
        
        if #available(iOS 15.0, *) {
            
            if let sheetPresentationController = navController.sheetPresentationController {
                
                sheetPresentationController.detents = [.medium()]
                
            }
            
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
