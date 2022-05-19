//
//  StudyGoalViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit
import PKHUD
import Lottie

enum TableViewCellType {
    
    case header
    
    case body
    
    case footer
    
    var identifier: String {
        
        switch self {
            
        case .header: return String(describing: TopTableViewCell.self)
            
        case .body: return String(describing: StudyGoalTableViewCell.self)
            
        case .footer: return String(describing: BottomTableViewCell.self)
            
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
    
    @IBOutlet var statusButton: [UIButton]!
    
    @IBOutlet weak var selectlineBackgroundView: UIView!
    
    @IBOutlet weak var headerAnimationView: UIView!
    
    @IBOutlet weak var studyGoalBackgroundView: UIView!
    
    var selectLineView = UIView()
    
    var lottieAnimation = AnimationView()
    
    // MARK: - Property
    var studyGoalManager = StudyGoalManager()
    
    var userManager = UserManager()
    
    var studyGoals: [StudyGoal] = []
    
    var user: UserInfo?
    
    var titleText = StatusType.running.title
    
    var tableViewCellType: [TableViewCellType] = [.header, .body, .footer]
    
    let dateFormatter = DateFormatter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIStyle()
        
        setHeaserLottieView()
        
        setSelectLineView()
        
        setNavigationItems()
        
        registerTableViewCell()
        
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addGoalButton.imageView?.contentMode = .scaleAspectFill
        
        addGoalButton.layer.cornerRadius = addGoalButton.frame.width / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lottieAnimation.play()
        
        fetchUserInfo()
        
        listenStudyGoals(status: titleText)
        
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
        
        selectlineBackgroundView.addSubview(selectLineView)
        
        selectLineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectLineView.topAnchor.constraint(equalTo: selectlineBackgroundView.topAnchor),
            selectLineView.centerXAnchor.constraint(equalTo: selectlineBackgroundView.centerXAnchor),
            selectLineView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / CGFloat(3.0)),
            selectLineView.heightAnchor.constraint(equalToConstant: selectlineBackgroundView.frame.height)
        ])
        
    }
    
    func setHeaserLottieView() {
        
        lottieAnimation = AnimationView(name: "101546-study-abroad")
        
        headerAnimationView.addSubview(lottieAnimation)
        
        lottieAnimation.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lottieAnimation.centerXAnchor.constraint(equalTo: headerAnimationView.centerXAnchor),
            lottieAnimation.centerYAnchor.constraint(equalTo: headerAnimationView.centerYAnchor, constant: 50),
            lottieAnimation.widthAnchor.constraint(equalToConstant: headerAnimationView.frame.height * CGFloat(0.8)),
            lottieAnimation.heightAnchor.constraint(equalToConstant: headerAnimationView.frame.height * CGFloat(0.8))
        ])
        
        lottieAnimation.loopMode = .loop
        
    }
    
    func setUIStyle() {
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
        addGoalButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        addGoalButton.tintColor = UIColor.white
        
        studyGoalTableView.backgroundColor = UIColor.clear
        
        selectStatusColorButton(selectButton: statusButton[1])
        
        studyGoalBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
        selectlineBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        selectLineView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        headerAnimationView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        lottieAnimation.backgroundColor = UIColor.clear
        
        lottieAnimation.contentMode = .scaleAspectFit
        
    }
    
    // MARK: - Method
    func fetchUserInfo() {
        
        userManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let user):
                
                strongSelf.user = user
                
                strongSelf.handleSignInCount()
                
            case .failure:
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func handleSignInCount() {
        
        let today = dateFormatter.string(from: Date())
        
        guard var user = user else { return }
        
        if user.achievement.loginDates.filter({ $0 == today }).isEmpty {
            
            user.achievement.loginDates.append(today)
            
            userManager.updateData(user: user)
            
        }
        
    }
    
    func listenStudyGoals(status: String) {
        
        studyGoalManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.studyGoals = strongSelf.handleSelectStudyGoals(status: status, studyGoals: data)
                
                strongSelf.studyGoalBackgroundView.isHidden = (strongSelf.studyGoals.isEmpty) ? false : true
                
                strongSelf.studyGoalTableView.reloadData()
                
            case .failure:
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func selectStatusColorButton(selectButton: UIButton) {
        
        _ = statusButton.map({ $0.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText) })
        
        _ = statusButton.map({ $0.tintColor = UIColor.hexStringToUIColor(hex: ColorChat.blue.hexText) })
        
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
        
        guard KeyToken().userID != "" else {
            
            guard let authViewController = UIStoryboard.auth.instantiateViewController(
                withIdentifier: String(describing: AuthenticationViewController.self)
            ) as? AuthenticationViewController else { return }
            
            authViewController.modalPresentationStyle = .formSheet
            
            present(authViewController, animated: true, completion: nil)
            
            return
            
        }
        
        pushToPlanStudyGoalPage(studyGoal: nil)
        
    }
    
    @IBAction func handleStatusButton(_ sender: UIButton) {
        
        handleUserSignOut()
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.selectLineView.frame.origin.x = sender.frame.origin.x
            
        })
        
        selectStatusColorButton(selectButton: sender)
        
        if let titleText = sender.titleLabel?.text {
            
            listenStudyGoals(status: titleText)
            
            self.titleText = titleText
            
        }
        
    }
    
    func handleUserSignOut() {
        
        if KeyToken().userID == "" {
            
            studyGoalBackgroundView.isHidden = false
            
            studyGoals = []
            
            studyGoalTableView.reloadData()
            
        }
        
    }
    
    func pushToPlanStudyGoalPage(studyGoal: StudyGoal?) {
        
        let viewController = UIStoryboard.studyGoal.instantiateViewController(
            withIdentifier: String(describing: PlanStudyGoalViewController.self))
        
        guard let viewController = viewController as? PlanStudyGoalViewController else { return }
        
        viewController.studyGoal = studyGoal
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func handleSelectStudyGoals(status: String, studyGoals: [StudyGoal]) -> [StudyGoal] {
        
        var resultStudyGoals: [StudyGoal] = []
        
        for index in 0..<studyGoals.count {
            
            let isPending = studyGoals[index].studyItems.allSatisfy({ $0.isCompleted == false })
            
            let isFinish = studyGoals[index].studyItems.allSatisfy({ $0.isCompleted == true })
            
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
        
        var cell = UITableViewCell()
        
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
        
        cell.checkIsCompleted(isCompleted: studyGoals[indexPath.section].studyItems[indexPath.row - 1].isCompleted)
        
        cell.showStudyItem(studyItem: studyGoals[indexPath.section].studyItems[indexPath.row - 1])
        
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
            
            guard let strongSelf = self else { return }
            
            strongSelf.deleteStudyGoal(section: indexPath.section)
            
            HUD.flash(.labeledSuccess(title: "計劃已刪除！", subtitle: nil), delay: 0.5)
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alertController.addAction(agreeAction)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func deleteStudyGoal(section: Int) {
        
        studyGoalManager.deleteData(studyGoal: studyGoals[section])
        
        studyGoals.remove(at: section)
        
        let indexSet = NSMutableIndexSet()
        
        indexSet.add(section)
        
        studyGoalTableView.deleteSections(indexSet as IndexSet, with: UITableView.RowAnimation.left)
        
    }
    
    func handleStudyItemComplete(isCompleted: Bool, section: Int, row: Int) {
        
        studyGoals[section].studyItems[row - 1].isCompleted = isCompleted
        
        user?.achievement.experienceValue += (isCompleted) ? 50: -50
        
        studyGoalManager.updateData(studyGoal: studyGoals[section])
        
    }
    
    func handleStudyItemFinish(section: Int, row: Int) {
        
        guard let studyGoalsID = user?.achievement.completionGoals else { return }
        
        let allSatisfy = studyGoals[section].studyItems.allSatisfy({ $0.isCompleted == true })
        
        let isEmpty = studyGoalsID.filter({ $0 == studyGoals[section].id }).isEmpty
        
        if allSatisfy && isEmpty {
            
            HUD.flash(.labeledSuccess(title: "學習項目完成！", subtitle: nil))
            
            user?.achievement.completionGoals.append(studyGoals[section].id)
            
        } else if allSatisfy && !isEmpty {
            
            HUD.flash(.labeledSuccess(title: "學習項目完成！", subtitle: nil))
            
        } else if !allSatisfy && !isEmpty {
            
            let deleteIndex = studyGoalsID.getArrayIndex(studyGoals[section].id)[0]
            
            user?.achievement.completionGoals.remove(at: deleteIndex)
            
        } else {
            
            return
            
        }
        
        guard let user = user else { return }
        
        userManager.updateData(user: user)
        
    }
    
}

// MARK: - check study item is complete delegate
extension StudyGoalViewController: CheckStudyItemDelegate {
    
    func checkItemCompleted(studyGoalTableViewCell: StudyGoalTableViewCell, studyItemCompleted: Bool) {
        
        guard let indexPath = studyGoalTableView.indexPath(for: studyGoalTableViewCell) else { return }
        
        handleStudyItemComplete(isCompleted: studyItemCompleted, section: indexPath.section, row: indexPath.row)
        
        handleStudyItemFinish(section: indexPath.section, row: indexPath.row)
        
    }
    
}
