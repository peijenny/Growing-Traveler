//
//  NoteViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/29.
//

import UIKit
import PKHUD

class NoteViewController: BaseViewController {

    @IBOutlet weak var noteTableView: UITableView! {
        
        didSet {
            
            noteTableView.delegate = self
            
            noteTableView.dataSource = self

        }
        
    }
    
    @IBOutlet weak var noteSearchBar: UISearchBar!
    
    @IBOutlet weak var noteBackgroundView: UIView!
    
    @IBOutlet weak var bottomBackgroundView: UIView!
    
    var userManager = UserManager()
    
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()
        
        noteTableView.register(
            UINib(nibName: String(describing: NoteTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: NoteTableViewCell.self))
        
        noteSearchBar.delegate = self
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        bottomBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchNoteData()
        
    }
    
    func fetchNoteData() {
        
        userManager.fetchUserNoteData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let notes):
                
                self.notes = notes
                
                if self.notes.isEmpty {
                    
                    self.noteBackgroundView.isHidden = false
                    
                } else {
                    
                    self.noteBackgroundView.isHidden = true
                    
                }
                
                self.noteTableView.reloadData()
                
            case .failure:
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func setNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.create), style: .plain, target: self, action: #selector(addNewNote))
        
    }
    
    @objc func addNewNote(sender: UIButton) {
        
        guard let viewController = UIStoryboard.note.instantiateViewController(
            withIdentifier: String(describing: PublishNoteViewController.self)
        ) as? PublishNoteViewController else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: NoteTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? NoteTableViewCell else { return cell }
        
        cell.showNoteData(note: notes[indexPath.row])
        
        cell.selectionStyle = .none

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let viewController = UIStoryboard.note.instantiateViewController(
            withIdentifier: String(describing: NoteDetailViewController.self)
        ) as? NoteDetailViewController else { return }
        
        viewController.noteID = notes[indexPath.row].noteID
        
        viewController.noteUserID = KeyToken().userID
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "刪除"
        
    }
    
    func tableView(
        _ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let alertController = UIAlertController(
                title: "刪除學習筆記", message: "請問確定刪除個人筆記嗎？\n 刪除行為不可逆，將無法瀏覽此筆記！", preferredStyle: .alert)
            
            let agreeAction = UIAlertAction(title: "確認", style: .default) { _ in

                let note = self.notes[indexPath.row]
                
                self.userManager.deleteUserNoteData(note: note)
                
                self.notes.remove(at: indexPath.row)
                
                self.noteTableView.beginUpdates()

                self.noteTableView.deleteRows(at: [indexPath], with: .left)

                self.noteTableView.endUpdates()
                
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            
            alertController.addAction(agreeAction)
            
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
            
    }
    
}

extension NoteViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            fetchNoteData()
            
        } else {
            
            notes = notes.filter({ $0.noteTitle.lowercased().range(of: searchText.lowercased()) != nil })
            
            noteTableView.reloadData()
            
        }

    }
    
}
