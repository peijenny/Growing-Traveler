//
//  CategoryViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit

class CategoryViewController: UIViewController {
    
    var tableView = UITableView()
    
    var categoryManager = CategoryManager()
    
    var category: [Category]? {
        
        didSet {
            
            tableView.reloadData()
            
        }
        
    }
    
    var getSelectCategoryItem: ((_ item: Item) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
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
        
        dismiss(animated: true, completion: .none)
        
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
    
    func fetchData() {
        
        categoryManager.fetchData(completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.category = data
                
            case .failure(let error):
                
                print(error)
                
            }
            
        })
    }

}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return category?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return category?[section].items.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CategoryTableViewCell.self),
            for: indexPath
        )

        guard let cell = cell as? CategoryTableViewCell else { return cell }
        
        cell.categoryItemLabel.text = category?[indexPath.section].items[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return category?[section].title ?? ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = category?[indexPath.section].items[indexPath.row] else { return }
        
        getSelectCategoryItem?(item)
        
        dismiss(animated: true, completion: .none)
        
    }
    
}
