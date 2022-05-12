//
//  CategoryViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit
import PKHUD

class SelectCategoryViewController: UIViewController {
    
    var categoryTableView = UITableView()
    
    var getSelectCategoryItem: ((_ item: CategoryItem) -> Void)?
    
    var categoryManager = CategoryManager()
    
    var selectItem: CategoryItem?
    
    var category: [Category]? {
        
        didSet {
            
            categoryTableView.reloadData()
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "分類標籤"

        view.backgroundColor = UIColor.white
        
        fetchCategoryData()
        
        setTableView()
        
        setNavigationBar()
        
    }
    
    func fetchCategoryData() {
        
        categoryManager.fetchData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.category = data
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
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
    
    func setNavigationBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(selectCategoryButton)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(setClosePageButton)
        )
        
    }
    
    @objc func setClosePageButton(sender: UIButton) {
        
        dismiss(animated: true, completion: .none)
        
    }
    
    @objc func selectCategoryButton(sender: UIButton) {
        
        if let selectItem = selectItem {
            
            getSelectCategoryItem?(selectItem)
            
            dismiss(animated: true, completion: .none)
            
        } else {
            
            HUD.flash(.label("請選擇標籤！"), delay: 0.5)
            
        }
        
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
