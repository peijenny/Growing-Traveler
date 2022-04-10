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
    
    var selectStartDate = Date() {
        
        didSet {
            
            planStudyGoalTableView.reloadData()
            
        }
        
    }
    
    var selectEndDate = Date() {
        
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
    
    var studyItems: [StudyItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        planStudyGoalTableView.register(
            UINib(nibName: String(describing: PlanStudyGoalHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: PlanStudyGoalHeaderView.self)
        )
        
        planStudyGoalTableView.register(
            UINib(nibName: String(describing: StudyItemTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: StudyItemTableViewCell.self)
        )
        
    }
    
}

extension PlanStudyGoalViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: StudyItemTableViewCell.self),
            for: indexPath
        )

        guard let cell = cell as? StudyItemTableViewCell else { return cell }
        
        cell.deleteItemButton.addTarget(
            self,
            action: #selector(deleteItemButton),
            for: .touchUpInside
        )
        
        cell.showStudyItem(
            itemTitle: studyItems[indexPath.row].itemTitle,
            studyTime: studyItems[indexPath.row].studyTime)
        
        return cell
        
    }
    
    @objc func deleteItemButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: planStudyGoalTableView)

        if let indexPath = planStudyGoalTableView.indexPathForRow(at: point) {

            studyItems.remove(at: indexPath.row)

            planStudyGoalTableView.beginUpdates()

            planStudyGoalTableView.deleteRows(at: [indexPath], with: .left)

            planStudyGoalTableView.endUpdates()
            
        }
        
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
            
            headerView.startDateLabel.text = formatter.string(from: selectStartDate)
            
        } else if selectDateType == SelectDateType.endDate.title {
            
            headerView.endDateLabel.text = formatter.string(from: selectEndDate)
            
        }
        
        guard let categoryItemTitle = selectCategoryItem?.title else { return headerView }
        
        headerView.categoryTagLabel.text = categoryItemTitle
        
        return headerView

    }
    
    @objc func selectStartDateButton(sender: UIButton) {
        
        selectCalenderViewController.startDate = Date()
        
        selectCalenderViewController.getSelectDate = { [weak self] date in
            
            self?.selectStartDate = date
            
            self?.selectDateType = SelectDateType.startDate.title
            
        }
        
        setSelectCalenderViewController()
        
    }
    
    @objc func selectEndDateButton(sender: UIButton) {
        
        selectCalenderViewController.startDate = selectStartDate
        
        selectCalenderViewController.getSelectDate = { [weak self] date in
            
            self?.selectEndDate = date
            
            self?.selectDateType = SelectDateType.endDate.title
            
        }
        
        setSelectCalenderViewController()
        
    }
    
    func setSelectCalenderViewController() {
        
        selectCalenderViewController.calendar.reloadData()
        
        let navController = UINavigationController(rootViewController: selectCalenderViewController)
        
        if let sheetPresentationController = navController.sheetPresentationController {
            
            sheetPresentationController.detents = [.medium()]
            
        }
        
        self.present(navController, animated: true, completion: nil)
        
    }
    
    @objc func selectCategoryTagButton(sender: UIButton) {
        
        let categoryViewController = SelectCategoryViewController()
        
        categoryViewController.getSelectCategoryItem = { [weak self] item in
            
            self?.selectCategoryItem = item
            
        }
        
        let navController = UINavigationController(rootViewController: categoryViewController)
        
        if let sheetPresentationController = navController.sheetPresentationController {
            
            sheetPresentationController.detents = [.medium()]
            
        }
        
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
        
        selectStudyItemViewController.getStudyItem = { [weak self] studyItem in
            
            self?.studyItems.append(studyItem)
            
            self?.planStudyGoalTableView.reloadData()
            
        }
        
    }
    
}
