//
//  NoteViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/29.
//

import UIKit

class NoteViewController: BaseViewController {

    @IBOutlet weak var searchNoteTextField: UITextField!
    
    @IBOutlet weak var noteTableView: UITableView! {
        
        didSet {
            
            noteTableView.delegate = self
            
            noteTableView.dataSource = self
            
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
        
        
    }
    
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: NoteTableViewCell.self), for: indexPath)
        
        guard let cell = cell as? NoteTableViewCell else { return cell }

        return cell
        
    }
    
}
