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

// MARK: - 檢查項目是否為空
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
    
    let selectCalenderViewController = SelectCalendarViewController()
    
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
    
    var isOpenEdited = false
    
    var userManager = UserManager()
    
    var user: UserInfo?
    
    var selectedDate: Date?
    
    var getSelectedDate: ((_ selectedDate: Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if studyGoal == nil {
            
            title = "新增個人學習計劃"
            
        } else {
            
            title = "編輯個人學習計劃"
            
        }
        
        if selectedDate != nil {
            
            getSelectedDate?(selectedDate ?? Date())
            
        }
        
        planStudyGoalTableView.register(
            UINib(nibName: String(describing: PlanStudyGoalHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: PlanStudyGoalHeaderView.self))
        
        planStudyGoalTableView.register(
            UINib(nibName: String(describing: StudyItemTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: StudyItemTableViewCell.self))
        
        // MARK: - 確認送出資料 Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(submitButton))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        modifyPlanStudyGoalSetting()
        
        fetchUserData()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func fetchUserData() {
        
        userManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let user):
                
                strongSelf.user = user
                
                strongSelf.planStudyGoalTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    // MARK: - 修改個人學習計劃設定
    func modifyPlanStudyGoalSetting() {
        
        studyItems = studyGoal?.studyItems ?? []
        
        selectCategoryItem = studyGoal?.category
        
        selectStartDate = Date(
            timeIntervalSince1970: studyGoal?.studyPeriod.startDate ?? TimeInterval()
        )
        
        selectEndDate = Date(
            timeIntervalSince1970: studyGoal?.studyPeriod.endDate ?? TimeInterval()
        )
        
    }
    
    @objc func submitButton(sender: UIButton) {
        
        checkStudyGoalFillIn = true
        
        planStudyGoalTableView.reloadData()
            
    }
    
}

// MARK: - TableView DataSource
extension PlanStudyGoalViewController: UITableViewDataSource {

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
        
        cell.selectionStyle = .none
        
        studyItems = studyItems.sorted { (lhs, rhs) in
            
            return lhs.id ?? 0 < rhs.id ?? 0
            
        }
        
        cell.showStudyItem(
            itemTitle: studyItems[indexPath.row].itemTitle,
            studyTime: studyItems[indexPath.row].studyTime)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        popupSelectStudyItemPage(
            studyItem: studyItems[indexPath.row],
            selectRow: indexPath.row
        )

    }
    
    // MARK: - tableView Row 可以被修改
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    // MARK: - 移動 TableView Row (修改排序 id)
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        studyItems[sourceIndexPath.row].id = destinationIndexPath.row

        studyItems[destinationIndexPath.row].id = sourceIndexPath.row
        
    }
    
    // MARK: - 刪除 TableView Row
    func tableView(_ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "刪除") {  _, _, _ in
            
            self.studyItems.remove(at: indexPath.row)
            
            self.planStudyGoalTableView.beginUpdates()

            self.planStudyGoalTableView.deleteRows(at: [indexPath], with: .left)

            self.planStudyGoalTableView.endUpdates()
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
        
    }

}

// MARK: - TableView Delegate
extension PlanStudyGoalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: PlanStudyGoalHeaderView.self))

        guard let headerView = headerView as? PlanStudyGoalHeaderView else { return headerView }
        
        headerView.studyGoalTitleTextField.delegate = self
        
        if checkStudyGoalFillIn == true {
            
            if headerView.checkFullIn(itemCount: studyItems.count,
                startDate: selectStartDate, endDate: selectEndDate) {
                
                if studyGoal != nil {
                    
                    addStudyGoalToDatabase(
                        id: studyGoal?.id ?? "",
                        title: headerView.studyGoalTitleTextField.text ?? ""
                    )
                    
                } else {
                    
                    addStudyGoalToDatabase(
                        id: studyGoalManager.database.document().documentID,
                        title: headerView.studyGoalTitleTextField.text ?? ""
                    )
                    
                }
                
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
        
        headerView.categoryTextField.text = selectCategoryItem?.title ?? ""
        
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
        
        studyGoal = StudyGoal(
            id: id,
            title: title,
            category: selectCategoryItem,
            studyPeriod: StudyPeriod(
                startDate: selectStartDate.timeIntervalSince1970,
                endDate: selectEndDate.timeIntervalSince1970),
            studyItems: studyItems,
            createTime: TimeInterval(Int(Date().timeIntervalSince1970)),
            userID: userID
        )
        
        if let studyGoal = studyGoal {
            
            guard var user = user else { return }
            
            var deleteIndex: Int?
            
            for index in 0..<user.achievement.completionGoals.count {
                
                if studyGoal.id == user.achievement.completionGoals[index] {
                    
                    deleteIndex = index
                    
                }
            }
            
            if deleteIndex != nil {
                
                user.achievement.completionGoals.remove(at: deleteIndex ?? 0)
                
                let userManager = UserManager()
                
                userManager.updateData(user: user)
                
            }
            
            studyGoalManager.addData(studyGoal: studyGoal)
            
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    @objc func editStudyItemButton(sender: UIButton) {
        
        if isOpenEdited {
            
            isOpenEdited = false
            
        } else {
            
            isOpenEdited = true
            
        }
        
        planStudyGoalTableView.isEditing = isOpenEdited
        
    }
    
    @objc func selectStartDateButton(sender: UIButton) {
        
        selectCalenderViewController.startDate = Date()
        
        selectCalenderViewController.getSelectDate = { [weak self] date in
            
            guard let strongSelf = self else { return }
            
            strongSelf.selectStartDate = date
            
            strongSelf.selectDateType = SelectDateType.startDate.title
            
        }
        
        setSelectCalenderViewController()
        
    }
    
    @objc func selectEndDateButton(sender: UIButton) {
        
        if selectStartDate >= Date() {
            
            selectCalenderViewController.startDate = selectStartDate
            
        } else {
            
            selectCalenderViewController.startDate = Date()
            
        }
        
        selectCalenderViewController.getSelectDate = { [weak self] date in
            
            guard let strongSelf = self else { return }
            
            strongSelf.selectEndDate = date
            
            strongSelf.selectDateType = SelectDateType.endDate.title
            
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
        
        selectStudyItemViewController.itemNumber = studyItems.count
        
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
    
}
