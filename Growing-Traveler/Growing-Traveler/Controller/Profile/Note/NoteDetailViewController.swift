//
//  NoteDetailViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/30.
//

import UIKit

class NoteDetailViewController: UIViewController {

    @IBOutlet weak var noteCreateTimeLabel: UILabel!
    
    @IBOutlet weak var noteDatailTableView: UITableView! {
        
        didSet {
            
            noteDatailTableView.delegate = self
            
            noteDatailTableView.dataSource = self
            
        }
        
    }
    
    var modifyNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = modifyNote?.noteID ?? ""
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        
        let createTime = Date(
            timeIntervalSince1970: modifyNote?.createTime ?? TimeInterval())
        
        noteCreateTimeLabel.text = formatter.string(from: createTime)

        setNavigationItems()
        
        noteDatailTableView.register(
            UINib(nibName: String(describing: ArticleDetailTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: ArticleDetailTableViewCell.self)
        )
        
    }
    
    func setNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit, target: self,
            action: #selector(modifyNoteData)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func modifyNoteData(sender: UIButton) {
        
        guard let viewController = UIStoryboard.profile.instantiateViewController(
                withIdentifier: String(describing: PublishNoteViewController.self)
                ) as? PublishNoteViewController else { return }
        
        viewController.modifyNote = modifyNote
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension NoteDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return modifyNote?.content.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ArticleDetailTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? ArticleDetailTableViewCell else { return cell }
        
        cell.selectionStyle = .none
        
        if let content = modifyNote?.content {
            
            cell.setArticleContent(content: content[indexPath.row])
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ArticleDetailTableViewCell.self),
            for: indexPath
        )
        
        guard let cell = cell as? ArticleDetailTableViewCell else { return }
        
        if modifyNote?.content[indexPath.row].contentType ?? "" == "image" {
            
            cell.contentImageView.loadImage(
                modifyNote?.content[indexPath.row].contentText)
            
            cell.contentImageView.showPhoto(imageView: cell.contentImageView)
            
        }
        
    }
    
}
