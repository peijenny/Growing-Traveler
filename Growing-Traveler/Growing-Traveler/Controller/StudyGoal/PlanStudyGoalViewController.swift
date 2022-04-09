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
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: PlanStudyGoalHeaderView.self)
        )

        guard let headerView = headerView as? PlanStudyGoalHeaderView else { return headerView }
        
        headerView.startDateCalenderButton.addTarget(
            self,
            action: #selector(selectStartDateButton),
            for: .touchUpInside
        )
        
        headerView.endDateCalenderButton.addTarget(
            self,
            action: #selector(selectEndDateButton),
            for: .touchUpInside
        )
        
        headerView.categoryTagButton.addTarget(
            self,
            action: #selector(selectCategoryTagButton),
            for: .touchUpInside
        )
        
        headerView.addStudyItemButton.addTarget(
            self,
            action: #selector(addStudyItemButton),
            for: .touchUpInside
        )
        
        return headerView

    }
    
    @objc func selectStartDateButton(sender: UIButton) {
        
        // 跳出選擇開始日期的 Calender
        
    }
    
    @objc func selectEndDateButton(sender: UIButton) {
        
        // 跳出選擇結束日期的 Calender
        
    }
    
    @objc func selectCategoryTagButton(sender: UIButton) {
        
        // 跳出選擇 Category Tag
        
    }
    
    @objc func addStudyItemButton(sender: UIButton) {
        
        // 跳出輸入框
        
    }
    
}
