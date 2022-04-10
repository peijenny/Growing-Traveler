//
//  PlanStudyGoalViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit

enum SelectDateType {
    
    case startDate
    
    case endDate
    
    var title: String {
        
        switch self {
            
        case .startDate: return "start"
            
        case .endDate: return "end"
            
        }
    }
}

class PlanStudyGoalViewController: UIViewController {

    @IBOutlet weak var planStudyGoalTableView: UITableView! {
        
        didSet {
            
            planStudyGoalTableView.delegate = self
            
            planStudyGoalTableView.dataSource = self
            
        }

    }
    
    let selectCalenderViewController = SelectCalendarViewController()
    
    var formatter = DateFormatter()
    
    var selectDate = Date() {
        
        didSet {
            
            planStudyGoalTableView.reloadData()
            
        }
        
    }
    
    var selectDateType = String()
    
    var selectCategoryItem: Item? {
        
        didSet {
            
            planStudyGoalTableView.reloadData()
            
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
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        if selectDateType == SelectDateType.startDate.title {
            
            headerView.startDateLabel.text = formatter.string(from: selectDate)
            
        } else if selectDateType == SelectDateType.endDate.title {
            
            headerView.endDateLabel.text = formatter.string(from: selectDate)
            
        }
        
        guard let categoryItemTitle = selectCategoryItem?.title else { return headerView }
        
        headerView.categoryTagLabel.text = categoryItemTitle
        
        return headerView

    }
    
    @objc func selectStartDateButton(sender: UIButton) {
        
        selectCalenderViewController.startDate = Date()
        
        selectCalenderViewController.getSelectDate = { [weak self] date in
            
            self?.selectDate = date
            
            self?.selectDateType = SelectDateType.startDate.title
            
        }
        
        setSelectCalenderViewController()
        
    }
    
    @objc func selectEndDateButton(sender: UIButton) {
        
        selectCalenderViewController.startDate = selectDate
        
        selectCalenderViewController.getSelectDate = { [weak self] date in
            
            self?.selectDate = date
            
            self?.selectDateType = SelectDateType.endDate.title
            
        }
        
        setSelectCalenderViewController()
        
    }
    
    func setSelectCalenderViewController() {
        
        selectCalenderViewController.view.backgroundColor = UIColor.systemGray5
        
        view.addSubview(selectCalenderViewController.view)
        
        selectCalenderViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectCalenderViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectCalenderViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            selectCalenderViewController.view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            selectCalenderViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])

        self.addChild(selectCalenderViewController)
        
        selectCalenderViewController.calendar.reloadData()
        
    }
    
    @objc func selectCategoryTagButton(sender: UIButton) {
        
        let categoryViewController = SelectCategoryViewController()
        
        categoryViewController.getSelectCategoryItem = { [weak self] item in
            
            self?.selectCategoryItem = item
            
        }
        
        let navController = UINavigationController(rootViewController: categoryViewController)
        
        self.present(navController, animated: true, completion: nil)
        
    }
    
    @objc func addStudyItemButton(sender: UIButton) {

        guard let selectStudyItemViewController = UIStoryboard
            .studyGoal
            .instantiateViewController(
                withIdentifier: String(describing: SelectStudyItemViewController.self)
                ) as? SelectStudyItemViewController else {

                    return

                }

        selectStudyItemViewController.view.center = view.center

        self.view.addSubview(selectStudyItemViewController.view)

        self.addChild(selectStudyItemViewController)
        
    }
    
}
