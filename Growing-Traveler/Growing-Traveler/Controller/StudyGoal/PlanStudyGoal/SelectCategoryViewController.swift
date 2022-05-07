//
//  CategoryViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit

class SelectCategoryViewController: UIViewController {
    
    var categoryTableView = UITableView()
    
    var categoryManager = CategoryManager()
    
    var category: [Category]? {
        
        didSet {
            
            categoryTableView.reloadData()
            
        }
        
    }
    
    var getSelectCategoryItem: ((_ item: CategoryItem) -> Void)?

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
        
        setTableView()
        
    }
    
    @objc func setClosePageButton() {
        
        dismiss(animated: true, completion: .none)
        
    }
    
    func setTableView() {
        
        categoryTableView.separatorInset.right = 15.0
        
        view.addSubview(categoryTableView)
        
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            categoryTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            categoryTableView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        categoryTableView.register(
            UINib(nibName: String(describing: CategoryTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: CategoryTableViewCell.self)
        )

        categoryTableView.delegate = self
        
        categoryTableView.dataSource = self
        
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

extension SelectCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
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
