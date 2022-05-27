//
//  CategoryViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit

class SelectCategoryViewController: UIViewController {
    
    // MARK: - IBOutlet / Components
    var categoryTableView = UITableView()
    
    // MARK: - Property
    var getSelectCategoryItem: ((_ item: CategoryItem) -> Void)?
    
    var categoryManager = CategoryManager()
    
    var selectItem: CategoryItem?
    
    var category: [Category]? {
        
        didSet {
            
            categoryTableView.reloadData()
            
        }
        
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "分類標籤"

        view.backgroundColor = UIColor.white
        
        fetchCategoryData()
        
        setTableView()
        
        setNavigationBar()
        
    }
    
    // MARK: - Set UI
    func setNavigationBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(selectCategoryButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(setClosePageButton))
        
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
            forCellReuseIdentifier: String(describing: CategoryTableViewCell.self))

        categoryTableView.delegate = self
        
        categoryTableView.dataSource = self
        
    }
    
    // MARK: - Method
    func fetchCategoryData() {
        
        categoryManager.fetchData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let data):
                
                self.category = data
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    // MARK: - Target / IBAction
    @objc func setClosePageButton(sender: UIButton) {
        
        dismiss(animated: true, completion: .none)
        
    }
    
    @objc func selectCategoryButton(sender: UIButton) {
        
        if let selectItem = selectItem {
            
            getSelectCategoryItem?(selectItem)
            
            dismiss(animated: true, completion: .none)
            
        } else {
            
            HandleInputResult.selectCategory.messageHUD
            
        }
        
    }

}

// MARK: - TableView delegate / dataSource
extension SelectCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return category?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return category?[section].items.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CategoryTableViewCell.self), for: indexPath)

        guard let cell = cell as? CategoryTableViewCell else { return cell }
        
        cell.categoryItemLabel.text = category?[indexPath.section].items[indexPath.row].title
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return category?[section].title ?? ""
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectItem = category?[indexPath.section].items[indexPath.row] else { return }
        
        self.selectItem = selectItem
        
    }
    
}
