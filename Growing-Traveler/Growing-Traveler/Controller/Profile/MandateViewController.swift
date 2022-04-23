//
//  MandateViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/22.
//

import UIKit
import Lottie

class MandateViewController: UIViewController {
    
    var mandateTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()

        title = "成長任務"
        
        view.backgroundColor = UIColor.white
        
    }
    
    func setTableView() {
        
        mandateTableView.backgroundColor = UIColor.clear
        
        mandateTableView.separatorStyle = .none
        
        view.addSubview(mandateTableView)
        
        mandateTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mandateTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            mandateTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mandateTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mandateTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -160.0)
        ])
        
        mandateTableView.register(
            UINib(nibName: String(describing: MandateTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: MandateTableViewCell.self)
        )

        mandateTableView.delegate = self
        
        mandateTableView.dataSource = self
        
    }
    
}

extension MandateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MandateTableViewCell.self),
            for: indexPath)
        
        guard let cell = cell as? MandateTableViewCell else { return cell }
        
        cell.mandateProgressView.layer.masksToBounds = true
        
        cell.mandateProgressView.layer.cornerRadius = 8.5
        
//        cell.mandateProgressView.setProgress(0.7, animated: true)
        
        cell.mandateProgressView.progress = 1
                
        return cell
        
    }
    
}
