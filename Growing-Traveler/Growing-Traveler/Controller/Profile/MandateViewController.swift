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
    
    var mandateManager = MandateManager()
    
    var mandates: [Mandate] = [] {
        
        didSet {
            
            fetchOwnerData()
            
        }
        
    }
    
    var ownMandates: [Mandate] = [] {
        
        didSet {
            
            mandateTableView.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()

        title = "成長任務"
        
        view.backgroundColor = UIColor.white
        
        fetchData()
        
    }
    
    func fetchOwnerData() {
        
        mandateManager.fetchOwnerData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            
            case .success(let mandates):
                
                if mandates.count == 0 {
                 
                    strongSelf.mandateManager.addData(mandates: strongSelf.mandates)
                    
                    strongSelf.ownMandates = strongSelf.mandates
                    
                } else {
                    
                    strongSelf.ownMandates = mandates

                }

            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func fetchData() {
        
        mandateManager.fetchMandateData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            
            case .success(let mandates):
                
                strongSelf.mandates = mandates

            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
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
        
        return ownMandates.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ownMandates[section].mandate.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MandateTableViewCell.self),
            for: indexPath)
        
        guard let cell = cell as? MandateTableViewCell else { return cell }
        
        let mandateItem = ownMandates[indexPath.section].mandate[indexPath.row]
        
        cell.showMandateItem(mandateItem: mandateItem)
        
        return cell
        
    }
    
}
