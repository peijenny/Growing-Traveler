//
//  StudyGoalViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit
import PKHUD
import Lottie

enum TableViewCellType: CaseIterable { // have to modify
    
    case header
    
    case body
    
    case footer
    
    var identifier: String {
        
        switch self {
            
        case .header: return "\(TopTableViewCell.self)"
            
        case .body: return "\(StudyGoalTableViewCell.self)"
            
        case .footer: return "\(BottomTableViewCell.self)"
            
        }
        
    }
    
}

class StudyGoalViewController: UIViewController {
    
    // MARK: - IBOutlet / Components
    @IBOutlet weak var studyGoalTableView: UITableView! {
        
        didSet {
            
            studyGoalTableView.delegate = self
            
            studyGoalTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var addGoalButton: UIButton!
    
    @IBOutlet var statusButtons: [UIButton]!
    
    @IBOutlet weak var selectedLineBackgroundView: UIView!
    
    @IBOutlet weak var headerAnimationView: UIView!
    
    @IBOutlet weak var studyGoalBackgroundView: UIView!
    
    var selectedLineView = UIView()
    
    var animationView = AnimationView()
    
    // MARK: - Property
    var studyGoalManager = StudyGoalManager()
    
    var userManager = UserManager()
    
    var selectedStatus: StatusType = .running
    
    let studyStatus: [StatusType] = [.pending, .running, .finished]
    
    let tableViewCellType: [TableViewCellType] = [.header, .body, .footer]
    
    var studyGoals: [StudyGoal] = []
    
    var user: UserInfo?
    
    private let dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter
        
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIStyle()
        
        setHeaderLottieView()
        
        setSelectLineView()
        
        setNavigationItems()
        
        registerTableViewCell()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addGoalButton.imageView?.contentMode = .scaleAspectFill
        
        addGoalButton.layer.cornerRadius = addGoalButton.frame.width / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animationView.play()
        
        fetchUserInfo()
        
        listenStudyGoals(status: selectedStatus)
        
        handleUserSignOut()
        
    }
    
    // MARK: - Set UI
    func setNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.calendar), style: .plain, target: self, action: #selector(pushToCalenderPage))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.award), style: .plain, target: self, action: #selector(pushToRankPage))
        
    }
    
    func registerTableViewCell() {
        
        studyGoalTableView.register(
            UINib(nibName: TableViewCellType.header.identifier, bundle: nil),
            forCellReuseIdentifier: TableViewCellType.header.identifier)
        
        studyGoalTableView.register(
            UINib(nibName: TableViewCellType.body.identifier, bundle: nil),
            forCellReuseIdentifier: TableViewCellType.body.identifier)
        
        studyGoalTableView.register(
            UINib(nibName: TableViewCellType.footer.identifier, bundle: nil),
            forCellReuseIdentifier: TableViewCellType.footer.identifier)
        
    }
    
    func setSelectLineView() {
        
        selectedLineBackgroundView.addSubview(selectedLineView)
        
        selectedLineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectedLineView.topAnchor.constraint(equalTo: selectedLineBackgroundView.topAnchor),
            selectedLineView.centerXAnchor.constraint(equalTo: selectedLineBackgroundView.centerXAnchor),
            selectedLineView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / CGFloat(3.0)),
            selectedLineView.heightAnchor.constraint(equalToConstant: selectedLineBackgroundView.frame.height)
        ])
        
    }
    
    func setHeaderLottieView() {
        
        animationView = AnimationView(name: "101546-study-abroad")
        
        headerAnimationView.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: headerAnimationView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: headerAnimationView.centerYAnchor, constant: 50),
            animationView.widthAnchor.constraint(equalToConstant: headerAnimationView.frame.height * CGFloat(0.8)),
            animationView.heightAnchor.constraint(equalToConstant: headerAnimationView.frame.height * CGFloat(0.8))
        ])
        
        animationView.loopMode = .loop
        
    }
    
    func setUIStyle() {
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
        addGoalButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        addGoalButton.tintColor = UIColor.white
        
        studyGoalTableView.backgroundColor = UIColor.clear
        
        studyGoalBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
        selectedLineBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        selectedLineView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        headerAnimationView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        animationView.backgroundColor = UIColor.clear
        
        animationView.contentMode = .scaleAspectFit
        
        for index in 0..<studyStatus.count {
            
            if studyStatus[index] == selectedStatus {
                
                selectStatusColorButton(selectButton: statusButtons[index])
                
            }
        }
        
    }
    
    // MARK: - Method
    func fetchUserInfo() {
        
        userManager.listenData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let user):
                
                self.user = user
                
                self.handleSignInNumberOfTime()
                
            case .failure:
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5) //
                
            }
            
        }
        
    }
    
    func handleSignInNumberOfTime() {
        
        let today = dateFormatter.string(from: Date())
        
        guard var user = user else { return }
        
        if user.achievement.loginDates.filter({ $0 == today }).isEmpty {
            
            user.achievement.loginDates.append(today)
            
            userManager.updateData(user: user)
            
        }
        
    }
    
    func listenStudyGoals(status: StatusType) {
        
        studyGoalManager.listenData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let data):
                
                self.studyGoals = self.handleSelectStudyGoals(status: status.title, studyGoals: data)
                
                self.studyGoalBackgroundView.isHidden = !self.studyGoals.isEmpty
                
                self.studyGoalTableView.reloadData()
                
            case .failure:
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5) //
                
            }
            
        }
        
    }
    
    func selectStatusColorButton(selectButton: UIButton) {
        
        for index in 0..<statusButtons.count {
            
            statusButtons[index].backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
            
            statusButtons[index].tintColor = UIColor.hexStringToUIColor(hex: ColorChat.blue.hexText)
            
        }
        
        selectButton.tintColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
    }
    
    // MARK: - Target / IBAction
    @objc func pushToRankPage(sender: UIButton) {
        
        let viewController = UIStoryboard.studyGoal.instantiateViewController(
            withIdentifier: String(describing: RankViewController.self))
        
        guard let viewController = viewController as? RankViewController else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @objc func pushToCalenderPage(sender: UIButton) {
        
        let viewController = UIStoryboard.studyGoal.instantiateViewController(
            withIdentifier: String(describing: CalendarViewController.self))
        
        guard let viewController = viewController as? CalendarViewController else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func addStudyGoalButton(_ sender: UIButton) {
        
        guard !KeyToken().userID.isEmpty else {
            
            guard let authViewController = UIStoryboard.auth.instantiateViewController(
                withIdentifier: String(describing: AuthenticationViewController.self)
            ) as? AuthenticationViewController else { return }
            
            authViewController.modalPresentationStyle = .formSheet
            
            present(authViewController, animated: true, completion: nil)
            
            return
            
        }
        
        pushToPlanStudyGoalPage()
        
    }
    
    @IBAction func handleStatusButton(_ sender: UIButton) {
        
        handleUserSignOut()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            
            guard let self = self else { return }
            
            self.selectedLineView.frame.origin.x = sender.frame.origin.x
            
        }
        
        selectStatusColorButton(selectButton: sender)
        
        for index in 0..<statusButtons.count {
            
            if sender == statusButtons[index] {
                
                selectedStatus = studyStatus[index]
                
                listenStudyGoals(status: selectedStatus)
                
            }
            
        }
        
    }
    
    func handleUserSignOut() {
        
        if KeyToken().userID.isEmpty {
            
            studyGoalBackgroundView.isHidden = false
            
            studyGoals = []
            
            studyGoalTableView.reloadData()
            
        }
        
    }
    
    func pushToPlanStudyGoalPage(studyGoal: StudyGoal? = nil) {
        
        let viewController = UIStoryboard.studyGoal.instantiateViewController(
            withIdentifier: String(describing: PlanStudyGoalViewController.self))
        
        guard let viewController = viewController as? PlanStudyGoalViewController else { return }
        
        viewController.studyGoal = studyGoal
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func handleSelectStudyGoals(status: String, studyGoals: [StudyGoal]) -> [StudyGoal] {
        
        var resultStudyGoals: [StudyGoal] = []
        
        for index in 0..<studyGoals.count {
            
            let isPending = studyGoals[index].studyItems.allSatisfy({ !$0.isCompleted })
            
            let isFinish = studyGoals[index].studyItems.allSatisfy({ $0.isCompleted })
            
            let startDate = Date(timeIntervalSince1970: studyGoals[index].studyPeriod.startDate)
            
            let today = dateFormatter.date(from: dateFormatter.string(from: Date())) ?? Date()
            
            if status == StatusType.pending.title && isPending && startDate > today {
                
                resultStudyGoals.append(studyGoals[index])
                
            } else if status == StatusType.running.title && !isFinish && startDate <= today {
                
                resultStudyGoals.append(studyGoals[index])
                
            } else if status == StatusType.finished.title && isFinish {
                
                resultStudyGoals.append(studyGoals[index])
                
            }
            
        }
        
        return resultStudyGoals
        
    }
    
}

// MARK: - tableView delegate / dataSource
extension StudyGoalViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return studyGoals.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studyGoals[section].studyItems.count + 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        switch indexPath.row {
            
        case 0:
            
            cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.header.identifier, for: indexPath)
            
            showStudyGoalHeaderCell(indexPath: indexPath, cell)
            
        case tableView.numberOfRows(inSection: indexPath.section) - 1:
            
            cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.footer.identifier, for: indexPath)
            
            showStudyGoalFooterCell(indexPath: indexPath, cell)
            
        default:
            
            cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.body.identifier, for: indexPath)
            
            showStudyGoalItemCell(indexPath: indexPath, cell)
            
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            pushToPlanStudyGoalPage(studyGoal: studyGoals[indexPath.section])
            
        }
        
    }
    
    private func showStudyGoalHeaderCell(indexPath: IndexPath, _ cell: UITableViewCell) {
        
        guard let cell = cell as? TopTableViewCell else { return }
        
        cell.showStudyGoalHeader(studyGoal: studyGoals[indexPath.section], isCalendar: false)
        
    }
    
    private func showStudyGoalItemCell(indexPath: IndexPath, _ cell: UITableViewCell) {
        
        guard let cell = cell as? StudyGoalTableViewCell else { return }
        
        cell.delegate = self
        
        // study item row - indexPath.row minus header row cell
        let studyItemRow = indexPath.row - 1
        
        cell.checkIsCompleted(isCompleted: studyGoals[indexPath.section].studyItems[studyItemRow].isCompleted)
        
        cell.showStudyItem(studyItem: studyGoals[indexPath.section].studyItems[studyItemRow])
        
    }
    
    private func showStudyGoalFooterCell(indexPath: IndexPath, _ cell: UITableViewCell) {
        
        guard let cell = cell as? BottomTableViewCell else { return }
        
        cell.showStudyGoalBottom(studyGoal: studyGoals[indexPath.section])
        
        cell.deleteButton.addTarget(self, action: #selector(deleteStudyGoalButton), for: .touchUpInside)
        
    }
    
    @objc func deleteStudyGoalButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: studyGoalTableView)
        
        guard let indexPath = studyGoalTableView.indexPathForRow(at: point) else { return }
        
        let alertController = UIAlertController(
            title: "刪除個人學習計劃", message: "請問確定刪除此計劃嗎？\n 刪除行為不可逆，將無法再瀏覽此計劃！",
            preferredStyle: .alert)
        
        let agreeAction = UIAlertAction(title: "確認", style: .destructive) { [weak self] _ in
            
            guard let self = self else { return }
            
            self.deleteStudyGoal(indexPath: indexPath)
            
            HUD.flash(.labeledSuccess(title: "計劃已刪除！", subtitle: nil), delay: 0.5)
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alertController.addAction(agreeAction)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func deleteStudyGoal(indexPath: IndexPath) {
        
        studyGoalManager.deleteData(studyGoal: studyGoals[indexPath.section])
        
        studyGoals.remove(at: indexPath.section)
        
        let indexSet = NSMutableIndexSet()
        
        indexSet.add(indexPath.section)
        
        studyGoalTableView.deleteSections(indexSet as IndexSet, with: UITableView.RowAnimation.left)
        
    }
    
    func handleStudyItemComplete(isCompleted: Bool, indexPath: IndexPath) {
       
        // study item row - indexPath.row minus header row cell
        let studyItemRow = indexPath.row - 1
        
        studyGoals[indexPath.section].studyItems[studyItemRow].isCompleted = isCompleted
        
        user?.achievement.experienceValue += isCompleted ? 50: -50
        
        studyGoalManager.updateData(studyGoal: studyGoals[indexPath.section])
        
    }
    
    func handleStudyItemFinish(indexPath: IndexPath) {
        
        guard var user = user else { return }
        
        let studyGoalsID = user.achievement.completionGoals
        
        let allSatisfy = studyGoals[indexPath.section].studyItems.allSatisfy({ $0.isCompleted })
        
        let isEmpty = studyGoalsID.filter({ $0 == studyGoals[indexPath.section].id }).isEmpty
        
        if allSatisfy && isEmpty {
            
            HUD.flash(.labeledSuccess(title: "學習項目完成！", subtitle: nil))
            
            user.achievement.completionGoals.append(studyGoals[indexPath.section].id)
            
        } else if allSatisfy && !isEmpty {
            
            HUD.flash(.labeledSuccess(title: "學習項目完成！", subtitle: nil))
            
        } else if !allSatisfy && !isEmpty {
            
            let deleteIndex = studyGoalsID.getArrayIndex(studyGoals[indexPath.section].id)[0]
            
            user.achievement.completionGoals.remove(at: deleteIndex)
            
        }
        
        userManager.updateData(user: user)
        
    }
    
}

// MARK: - check study item is complete delegate
extension StudyGoalViewController: CheckStudyItemDelegate {
    
    func checkItemCompleted(studyGoalTableViewCell: StudyGoalTableViewCell, studyItemCompleted: Bool) {
        
        guard let indexPath = studyGoalTableView.indexPath(for: studyGoalTableViewCell) else { return }
        
        handleStudyItemComplete(isCompleted: studyItemCompleted, indexPath: indexPath)
        
        handleStudyItemFinish(indexPath: indexPath)
        
    }
    
}
