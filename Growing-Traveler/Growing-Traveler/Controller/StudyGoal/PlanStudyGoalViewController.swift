//
//  PlanStudyGoalViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit

class PlanStudyGoalViewController: UIViewController {

    @IBOutlet weak var planStudyGoalTableView: UITableView! {
        
        didSet {
            
            planStudyGoalTableView.delegate = self
            
            planStudyGoalTableView.dataSource = self
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        planStudyGoalTableView.register(
            UINib(nibName: String(describing: PlanStudyGoalHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: PlanStudyGoalHeaderView.self)
        )
        
    }
    
}

extension PlanStudyGoalViewController: UITableViewDelegate, UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: PlanStudyGoalHeaderView.self))

        guard let headerView = headerView as? PlanStudyGoalHeaderView else { return headerView }
        
        return headerView

    }
    
}
