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

enum InputError {
    
    case studyGoalTitleEmpty
    
    case startTimeEmpty
    
    case endTimeEmpty
    
    case categoryEmpty
    
    case studyItemEmpty
    
    var title: String {
        
        switch self {
            
        case .studyGoalTitleEmpty: return "標題不可為空！"
            
        case .startTimeEmpty: return "尚未選擇開始時間！"
            
        case .endTimeEmpty: return "尚未選擇結束時間！"
            
        case .categoryEmpty: return "尚未選擇分類標籤！"
            
        case .studyItemEmpty: return "學習項目不可為空！"
            
        }
        
    }
    
}

class PlanStudyGoalViewController: BaseViewController {

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
    
    var selectCategoryItem: CategoryItem? {
        
        didSet {
            
            planStudyGoalTableView.reloadData()
            
        }
        
    }
    
    var studyItems: [StudyItem] = []
    
    var checkStudyGoalFillIn = false
    
    var studyGoal: StudyGoal?
    
    let studyGoalManager = StudyGoalManager()
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(submitButton)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        modifyPlanStudyGoalSetting()
        
    }
    
    func modifyPlanStudyGoalSetting() {
        
        studyItems = studyGoal?.studyItems ?? []
        
        selectCategoryItem = studyGoal?.category
        
        selectStartDate = Date(
            timeIntervalSince1970: studyGoal?.studyPeriod.startTime ?? TimeInterval()
        )
        
        selectEndDate = Date(
            timeIntervalSince1970: studyGoal?.studyPeriod.endTime ?? TimeInterval()
        )
        
    }
    
    @objc func submitButton(sender: UIButton) {
        
        checkStudyGoalFillIn = true
        
        planStudyGoalTableView.reloadData()
            
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
            self, action: #selector(deleteItemButton),
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
            withIdentifier: String(describing: PlanStudyGoalHeaderView.self))

        guard let headerView = headerView as? PlanStudyGoalHeaderView else { return headerView }
        
        headerView.studyGoalTitleTextField.delegate = self
        
        if checkStudyGoalFillIn == true {

            if headerView.studyGoalTitleTextField.text == "" {

                headerView.hintLabel.text = InputError.studyGoalTitleEmpty.title

            } else if headerView.startDateTextField.text == "" {

                headerView.hintLabel.text = InputError.startTimeEmpty.title

            } else if headerView.endDateTextField.text == "" {

                headerView.hintLabel.text = InputError.endTimeEmpty.title

            } else if headerView.categoryTextField.text == "" {

                headerView.hintLabel.text = InputError.categoryEmpty.title

            } else if studyItems.count == 0 {

                headerView.hintLabel.text = InputError.studyItemEmpty.title

            } else {
                
                guard let selectCategoryItem = selectCategoryItem else { return headerView }
                
                if studyGoal != nil {
                    
                    studyGoal = StudyGoal(
                        id: studyGoal?.id ?? "",
                        title: headerView.studyGoalTitleTextField.text ?? "",
                        category: selectCategoryItem,
                        studyPeriod: StudyPeriod(startTime: selectStartDate.timeIntervalSince1970,
                                                 endTime: selectEndDate.timeIntervalSince1970),
                        studyItems: studyItems,
                        createTime: Date().timeIntervalSince1970,
                        userID: userID)
                    
                } else {
                    
                    studyGoal = StudyGoal(
                        id: studyGoalManager.database.document().documentID,
                        title: headerView.studyGoalTitleTextField.text ?? "",
                        category: selectCategoryItem,
                        studyPeriod: StudyPeriod(startTime: selectStartDate.timeIntervalSince1970,
                                                 endTime: selectEndDate.timeIntervalSince1970),
                        studyItems: studyItems,
                        createTime: Date().timeIntervalSince1970,
                        userID: userID)
                    
                }
                
                addStudyGoalToDatabase()
                
            }

            checkStudyGoalFillIn = false

        }

        headerView.startDateCalenderButton.addTarget(
            self, action: #selector(selectStartDateButton), for: .touchUpInside)
        
        headerView.endDateCalenderButton.addTarget(
            self, action: #selector(selectEndDateButton), for: .touchUpInside)
        
        headerView.categoryTagButton.addTarget(
            self, action: #selector(selectCategoryTagButton), for: .touchUpInside)
        
        headerView.addStudyItemButton.addTarget(
            self, action: #selector(addStudyItemButton), for: .touchUpInside)
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        if selectDateType == SelectDateType.startDate.title {
            
            headerView.startDateTextField.text = formatter.string(from: selectStartDate)
            
        } else if selectDateType == SelectDateType.endDate.title {
            
            headerView.endDateTextField.text = formatter.string(from: selectEndDate)
            
        }
        
        headerView.categoryTextField.text = selectCategoryItem?.title ?? ""
        
        if studyGoal != nil {
            
            guard let studyGoal = studyGoal else { return headerView }
            
            headerView.studyGoalTitleTextField.text = studyGoal.title
            
            headerView.startDateTextField.text = Date(
                timeIntervalSince1970: studyGoal.studyPeriod.startTime
            ).formatted()
            
            headerView.endDateTextField.text = Date(
                timeIntervalSince1970: studyGoal.studyPeriod.endTime
            ).formatted()
            
            headerView.categoryTextField.text = studyGoal.category.title
            
        }

        return headerView

    }
    
    func addStudyGoalToDatabase() {
        
        if let studyGoal = studyGoal {
            
            print("Test \(studyGoal)")
            
            studyGoalManager.addData(studyGoal: studyGoal)
            
            navigationController?.popViewController(animated: true)
            
        }
        
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
        
        selectCalenderViewController.calendarView.reloadData()
        
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

        popupSelectStudyItemPage(studyItem: nil, selectRow: nil)
        
    }
    
    func popupSelectStudyItemPage(studyItem: StudyItem?, selectRow: Int?) {
        
        guard let selectStudyItemViewController = UIStoryboard
            .studyGoal
            .instantiateViewController(
                withIdentifier: String(describing: SelectStudyItemViewController.self)
                ) as? SelectStudyItemViewController else {

                    return

                }
        
        selectStudyItemViewController.modifyStudyItem = studyItem

        selectStudyItemViewController.view.center = view.center

        self.view.addSubview(selectStudyItemViewController.view)

        self.addChild(selectStudyItemViewController)
        
        selectStudyItemViewController.getStudyItem = { [weak self] studyItem, whetherToUpdate in
            
            if whetherToUpdate == false {
                
                self?.studyItems.append(studyItem)
                
            } else {
                
                self?.studyItems[selectRow ?? 0] = studyItem
                
            }
            
            self?.planStudyGoalTableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("TEST")
        
        popupSelectStudyItemPage(
            studyItem: studyItems[indexPath.row],
            selectRow: indexPath.row)

    }
    
}
