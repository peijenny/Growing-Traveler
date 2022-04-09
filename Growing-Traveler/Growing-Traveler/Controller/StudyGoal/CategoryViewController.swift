//
//  CategoryViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit

class CategoryViewController: UIViewController {
    
    var fakeData = ["國文", "數學", "英文"]
    
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "分類標籤"

        view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(setClosePageButton)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        setTableView()
        
    }
    
    @objc func setClosePageButton() {
        
        self.dismiss(animated: true, completion: .none)
        
    }
    
    func setTableView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        tableView.register(
            UINib(nibName: String(describing: CategoryTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: CategoryTableViewCell.self)
        )

        tableView.delegate = self
        
        tableView.dataSource = self
        
    }
    
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fakeData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CategoryTableViewCell.self),
            for: indexPath
        )

        guard let cell = cell as? CategoryTableViewCell else { return cell }
        
        cell.categoryItemLabel.text = fakeData[indexPath.row]
        
        return cell
    }
    
}
