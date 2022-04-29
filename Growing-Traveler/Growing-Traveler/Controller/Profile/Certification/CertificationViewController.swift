//
//  CertificationViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/29.
//

import UIKit

class CertificationViewController: UIViewController {

    var certificationTableView = UITableView()
    
    var certifications: [Certification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "個人認證"
        
        view.backgroundColor = UIColor.white
        
        setTableView()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func setTableView() {
        
        certificationTableView.backgroundColor = UIColor.clear
        
        view.addSubview(certificationTableView)
        
        certificationTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            certificationTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            certificationTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            certificationTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            certificationTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -160.0)
        ])
        
//        certificationTableView.register(
//            UINib(nibName: String(describing: MoreArticlesTableViewCell.self), bundle: nil),
//            forCellReuseIdentifier: String(describing: MoreArticlesTableViewCell.self)
//        )

        certificationTableView.delegate = self
        
        certificationTableView.dataSource = self
        
    }

}

extension CertificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return certifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
        
    }
    
}
