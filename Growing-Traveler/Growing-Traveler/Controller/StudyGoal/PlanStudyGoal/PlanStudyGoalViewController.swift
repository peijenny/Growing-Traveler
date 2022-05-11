//
//  PlanStudyGoalViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit
import PKHUD

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
    
    case titleEmpty
    
    case startDateEmpty
    
    case endDateEmpty
    
    case studyTimeEmpty
    
    case categoryEmpty
    
    case studyItemEmpty
    
    case contentEmpty
    
    case startDatereLativelyLate
    
    var title: String {
        
        switch self {
            
        case .titleEmpty: return "標題不可為空！"
            
        case .startDateEmpty: return "尚未選擇開始日期！"
            
        case .endDateEmpty: return "尚未選擇結束日期！"
            
        case .studyTimeEmpty: return "請選擇項目的學習時間！"
            
        case .categoryEmpty: return "尚未選擇分類標籤！"
            
        case .studyItemEmpty: return "學習項目不可為空！"
            
        case .contentEmpty: return "內容輸入不可為空！"
            
        case .startDatereLativelyLate: return "開始日期大於結束日期！"
            
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
    
    var selectStartDate = Date()
    
    var selectEndDate = Date()
    
    var selectCategoryItem: CategoryItem?
    
    var selectCalenderViewController = SelectCalendarViewController()
    
    var getSelectedDate: ((_ selectedDate: Date) -> Void)?
    
    var studyGoalManager = StudyGoalManager()
    
    var userManager = UserManager()
    
    var studyItems: [StudyItem] = []
    
    var studyGoal: StudyGoal?
    
    var userInfo: UserInfo?
    
    var selectedDate: Date?
    
    var selectDateType = String()
    
    var checkStudyGoalFillIn = false
    
    var isOpenEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = studyGoal == nil ? "新增個人學習計劃" : "編輯個人學習計劃"
        
        if selectedDate != nil {
            
            getSelectedDate?(selectedDate ?? Date())
            
        }
        
        setNavigationItem()
        
        registerTableViewCell()
        
        fetchUserInfoData()
        
        modifyPlanStudyGoalSetting()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func fetchUserInfoData() {
        
        userManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let user):
                
                strongSelf.userInfo = user
                
                strongSelf.planStudyGoalTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func modifyPlanStudyGoalSetting() {
        
        studyItems = studyGoal?.studyItems ?? []
        
        selectCategoryItem = studyGoal?.category
        
        selectStartDate = Date(
            timeIntervalSince1970: studyGoal?.studyPeriod.startDate ?? TimeInterval())
        
        selectEndDate = Date(
            timeIntervalSince1970: studyGoal?.studyPeriod.endDate ?? TimeInterval())
        
    }
    
    func setNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(submitButton))
        
    }
    
    @objc func submitButton(sender: UIButton) {
        
        checkStudyGoalFillIn = true
        
        planStudyGoalTableView.reloadData()
            
    }
    
    
    func registerTableViewCell() {
        
        planStudyGoalTableView.register(
            UINib(nibName: String(describing: PlanStudyGoalHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: PlanStudyGoalHeaderView.self))
        
        planStudyGoalTableView.register(
            UINib(nibName: String(describing: StudyItemTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: StudyItemTableViewCell.self))
        
    }
    
}

extension PlanStudyGoalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studyItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: StudyItemTableViewCell.self), for: indexPath)

        guard let cell = cell as? StudyItemTableViewCell else { return cell }
        
        studyItems = studyItems.sorted { (lhs, rhs) in
            
            return lhs.id ?? 0 < rhs.id ?? 0
            
        }
        
        cell.showStudyItem(
            itemTitle: studyItems[indexPath.row].itemTitle, studyTime: studyItems[indexPath.row].studyTime)
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        popupSelectStudyItemPage(studyItem: studyItems[indexPath.row], selectRow: indexPath.row)

    }
    
    // MARK: - tableView row can be modify
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    // MARK: - move tableView row (sort by id)
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        studyItems[sourceIndexPath.row].id = destinationIndexPath.row

        studyItems[destinationIndexPath.row].id = sourceIndexPath.row
        
    }
    
    // MARK: - delete TableView Row
    func tableView(_ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "刪除") { [weak self]  _, _, _ in
            
            guard let strongSelf = self else { return }
            
            strongSelf.studyItems.remove(at: indexPath.row)
            
            strongSelf.planStudyGoalTableView.beginUpdates()

            strongSelf.planStudyGoalTableView.deleteRows(at: [indexPath], with: .left)

            strongSelf.planStudyGoalTableView.endUpdates()
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
        
    }

}

extension PlanStudyGoalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: PlanStudyGoalHeaderView.self))

        guard let headerView = headerView as? PlanStudyGoalHeaderView else { return headerView }
        
        headerView.studyGoalTitleTextField.delegate = self
        
        if checkStudyGoalFillIn {
            
            if headerView.checkFullIn(itemCount: studyItems.count,
                startDate: selectStartDate, endDate: selectEndDate) {
                
                var showLabelTitle = ""
                
                if studyGoal != nil {
                    
                    addStudyGoalToDatabase(
                        id: studyGoal?.id ?? "", title: headerView.studyGoalTitleTextField.text ?? "")
                    
                    showLabelTitle = "修改成功！"
                    
                } else {
                    
                    addStudyGoalToDatabase(
                        id: studyGoalManager.database.document().documentID, title: headerView.studyGoalTitleTextField.text ?? "")
                    
                    showLabelTitle = "新增成功！"
                    
                }
                
                HUD.flash(.labeledSuccess(title: showLabelTitle, subtitle: nil), delay: 0.5)
                
            }
            
            checkStudyGoalFillIn = false
            
        }
        
        headerView.modifyStudyGoal(studyGoal: studyGoal)
        
        if studyGoal != nil {
            
            guard let selectCategoryItem = selectCategoryItem else { return headerView }
            
            studyGoal?.category = selectCategoryItem
            
            studyGoal?.studyPeriod.startDate = selectStartDate.timeIntervalSince1970
            
            studyGoal?.studyPeriod.endDate = selectEndDate.timeIntervalSince1970
            
        }
        
        headerView.categoryLabel.text = selectCategoryItem?.title ?? "請選擇分類標籤"
        
        if headerView.categoryLabel.text ?? "" != "請選擇分類標籤" {
            
            headerView.categoryLabel.textColor = UIColor.black
            
        }
        
        let categoryTapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(selectCategoryTagButton))
        
        headerView.categoryLabel.addGestureRecognizer(categoryTapGestureRecognizer)
        
        let startDateTapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(selectStartDateButton))
        
        headerView.startDateLabel.addGestureRecognizer(startDateTapGestureRecognizer)
        
        let endDateTapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(selectEndDateButton))
        
        headerView.endDateLabel.addGestureRecognizer(endDateTapGestureRecognizer)
        
        headerView.showSelectedDate(dateType: selectDateType,
            startDate: selectStartDate, endDate: selectEndDate)

        headerView.startDateCalenderButton.addTarget(
            self, action: #selector(selectStartDateButton), for: .touchUpInside)
        
        headerView.endDateCalenderButton.addTarget(
            self, action: #selector(selectEndDateButton), for: .touchUpInside)
        
        headerView.categoryTagButton.addTarget(
            self, action: #selector(selectCategoryTagButton), for: .touchUpInside)
        
        headerView.addStudyItemButton.addTarget(
            self, action: #selector(addStudyItemButton), for: .touchUpInside)
        
        headerView.openEditButton.addTarget(
            self, action: #selector(editStudyItemButton), for: .touchUpInside)
        
        return headerView

    }
    
    func addStudyGoalToDatabase(id: String, title: String) {

        guard let selectCategoryItem = selectCategoryItem else { return }
        
        let studyPeriod = StudyPeriod(startDate: selectStartDate.timeIntervalSince1970, endDate: selectEndDate.timeIntervalSince1970)
        
        let createTime = TimeInterval(Int(Date().timeIntervalSince1970))
        
        studyGoal = StudyGoal(
            id: id, title: title, category: selectCategoryItem, studyPeriod: studyPeriod,
            studyItems: studyItems, createTime: createTime, userID: userID)
        
        if let studyGoal = studyGoal, var user = userInfo {
            
            var deleteIndex: Int?
            
            for index in 0..<user.achievement.completionGoals.count {
                
                if studyGoal.id == user.achievement.completionGoals[index] {
                    
                    deleteIndex = index
                    
                }
            }
            
            if deleteIndex != nil {
                
                user.achievement.completionGoals.remove(at: deleteIndex ?? 0)
                
                userManager.updateData(user: user)
                
            }
            
            studyGoalManager.addData(studyGoal: studyGoal)
            
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    @objc func editStudyItemButton(sender: UIButton) {
        
        isOpenEdited = isOpenEdited ? false : true
        
        planStudyGoalTableView.isEditing = isOpenEdited
        
    }
    
    @objc func selectStartDateButton(sender: UIButton) {
        
        selectCalenderViewController.startDate = Date()
        
        selectCalenderViewController.getSelectDate = { [weak self] date in
            
            guard let strongSelf = self else { return }
            
            strongSelf.selectStartDate = date
            
            strongSelf.selectDateType = SelectDateType.startDate.title
            
            strongSelf.planStudyGoalTableView.reloadData()
            
        }
        
        setSelectCalenderViewController()
        
    }
    
    @objc func selectEndDateButton(sender: UIButton) {
        
        selectCalenderViewController.startDate = selectStartDate >= Date() ? selectStartDate : Date()
        
        selectCalenderViewController.getSelectDate = { [weak self] date in
            
            guard let strongSelf = self else { return }
            
            strongSelf.selectEndDate = date
            
            strongSelf.selectDateType = SelectDateType.endDate.title
            
            strongSelf.planStudyGoalTableView.reloadData()
            
        }
        
        setSelectCalenderViewController()
        
    }
    
    func setSelectCalenderViewController() {
        
        selectCalenderViewController.calendarView.reloadData()
        
        let navController = UINavigationController(rootViewController: selectCalenderViewController)
        
        if #available(iOS 15.0, *) {
            
            if let sheetPresentationController = navController.sheetPresentationController {
                
                sheetPresentationController.detents = [.medium()]
                
            }
            
        } else {
            
            navController.modalPresentationStyle = .fullScreen
            
        }
        
        self.present(navController, animated: true, completion: nil)
        
    }
    
    @objc func selectCategoryTagButton(sender: UIButton) {
        
        let categoryViewController = SelectCategoryViewController()
        
        categoryViewController.getSelectCategoryItem = { [weak self] item in
            
            guard let strongSelf = self else { return }
            
            strongSelf.selectCategoryItem = item
            
            strongSelf.planStudyGoalTableView.reloadData()
            
        }
        
        let navController = UINavigationController(rootViewController: categoryViewController)
        
        if #available(iOS 15.0, *) {
            
            if let sheetPresentationController = navController.sheetPresentationController {
                
                sheetPresentationController.detents = [.medium()]
                
            }
            
        } else {
            
            navController.modalPresentationStyle = .fullScreen
        }
        
        self.present(navController, animated: true, completion: nil)
        
    }
    
    @objc func addStudyItemButton(sender: UIButton) {

        popupSelectStudyItemPage(studyItem: nil, selectRow: nil)
        
    }
    
    func popupSelectStudyItemPage(studyItem: StudyItem?, selectRow: Int?) {
        
        guard let selectStudyItemViewController = UIStoryboard.studyGoal.instantiateViewController(
            withIdentifier: String(describing: SelectStudyItemViewController.self)
        ) as? SelectStudyItemViewController else { return }
        
        selectStudyItemViewController.itemNumber = studyItems.count
        
        selectStudyItemViewController.modifyStudyItem = studyItem

        selectStudyItemViewController.view.center = view.center

        self.view.addSubview(selectStudyItemViewController.view)

        self.addChild(selectStudyItemViewController)
        
        self.navigationController?.isNavigationBarHidden = true
        
        selectStudyItemViewController.getStudyItem = { [weak self] studyItem, whetherToUpdate in
            
            guard let strongSelf = self else { return }
            
            if !whetherToUpdate {
                
                strongSelf.studyItems.append(studyItem)
                
            } else {
                
                strongSelf.studyItems[selectRow ?? 0] = studyItem
                
            }
            
            strongSelf.planStudyGoalTableView.reloadData()
            
        }
        
    }
    
}
