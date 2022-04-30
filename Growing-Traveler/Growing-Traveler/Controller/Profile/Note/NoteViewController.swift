//
//  NoteViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/29.
//

import UIKit
import PKHUD

class NoteViewController: BaseViewController {

    @IBOutlet weak var searchNoteTextField: UITextField!
    
    @IBOutlet weak var noteTableView: UITableView! {
        
        didSet {
            
            noteTableView.delegate = self
            
            noteTableView.dataSource = self
            
        }
        
    }
    
    var userManager = UserManager()
    
    var notes: [Note] = [] {
        
        didSet {
            
            noteTableView.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "個人學習筆記"

        setNavigationItems()
        
        noteTableView.register(
            UINib(nibName: String(describing: NoteTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: NoteTableViewCell.self)
        )
        
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
        
        userManager.fetchUserNoteData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let notes):
                
                strongSelf.notes = notes
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.label("資料獲取失敗！"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func setNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self,
            action: #selector(addNewNote)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func addNewNote() {
        
        guard let viewController = UIStoryboard.profile.instantiateViewController(
                withIdentifier: String(describing: PublishNoteViewController.self)
                ) as? PublishNoteViewController else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        
        guard let searchText = searchNoteTextField.text else { return }
        
        notes = notes.filter({ $0.noteTitle.range(of: searchText) != nil })
        
        if searchText == "" {
            
            fetchNoteData()
            
        }
    }
    
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: NoteTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? NoteTableViewCell else { return cell }
        
        cell.showNoteData(note: notes[indexPath.row])

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let viewController = UIStoryboard.profile.instantiateViewController(
                withIdentifier: String(describing: NoteDetailViewController.self)
                ) as? NoteDetailViewController else { return }
        
        viewController.modifyNote = notes[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
