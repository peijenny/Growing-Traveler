//
//  StudyGoalViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit
import PKHUD
import Lottie

//enum IndexPathRow {
//    
//    case header
//    
//    case body
//    
//    case footer
//    
//    var number: Int {
//        
//        switch self {
//            
//        case .header: return 1
//            
//        case .body: return 
//        }
//    }
//}

class StudyGoalViewController: UIViewController {
    
    @IBOutlet weak var studyGoalTableView: UITableView! {
        
        didSet {
            
            studyGoalTableView.delegate = self
            
            studyGoalTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var addGoalButton: UIButton!
    
    @IBOutlet var statusButton: [UIButton]!
    
    @IBOutlet weak var underlineView: UIView!
    
    @IBOutlet weak var headerAnimationView: UIView!
    
    @IBOutlet weak var studyGoalBackgroundView: UIView!
    
    var lottieAnimation = AnimationView()
    
    var selectLineView = UIView()
    
    var studyGoalManager = StudyGoalManager()
    
    var userManager = UserManager()
    
    var studyGoals: [StudyGoal] = []
    
    var user: UserInfo?
    
    var titleText = StatusType.running.title
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIStyle()
        
        setHeaserLottieView()
        
        setSelectLineView()
        
        setNavigationBar()
        
        registerTableViewCell()

    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lottieAnimation.play()
        
        fetchUserData()
        
        listenData(status: titleText)
        
        // MARK: login out and not login behavior
        handleUserIDIsEmpty()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // MARK: - set add study goal button style
        addGoalButton.imageView?.contentMode = .scaleAspectFill

        addGoalButton.layer.cornerRadius = addGoalButton.frame.width / 2
        
    }
    
    func fetchUserData() {
        
        userManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let user):
                
                strongSelf.user = user
                
                // MARK: - calculation number of times
                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy.MM.dd"

                let today = dateFormatter.string(from: Date())

                guard var user = strongSelf.user else { return }
                
                if user.achievement.loginDates.filter({ $0 == today }).isEmpty {
                    
                    user.achievement.loginDates.append(today)
                    
                    strongSelf.userManager.updateData(user: user)
                    
                }
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func listenData(status: String) {
        
        studyGoalManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.studyGoals = strongSelf.handleSelectStudyGoals(status: status, studyGoals: data)
                
                strongSelf.studyGoalBackgroundView.isHidden = (strongSelf.studyGoals.isEmpty) ? false : true
                
                strongSelf.studyGoalTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func setNavigationBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.calendar), style: .plain, target: self, action: #selector(pushToCalenderPage))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.award), style: .plain, target: self, action: #selector(pushToRankPage))
        
    }
    
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
        
        guard userID != "" else {
            
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
        
        handleUserIDIsEmpty()
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in

            guard let strongSelf = self else { return }
            
            strongSelf.selectLineView.frame.origin.x = sender.frame.origin.x
            
        })
        
        selectStatusColorButton(selectButton: sender)
        
        if let titleText = sender.titleLabel?.text {
            
            listenData(status: titleText)
            
            self.titleText = titleText
            
        }
        
    }
    
    func handleUserIDIsEmpty() {
        
        if userID == "" {
            
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
        
        var resultData: [StudyGoal] = []
        
        if status == StatusType.pending.title {

            resultData = studyGoals.filter({
                
                let isPending = $0.studyPeriod.startDate > Date().timeIntervalSince1970
                
                let notStartDoing = $0.studyItems.allSatisfy({ $0.isCompleted == false })
                
                return (notStartDoing && isPending) ? true : false
                
            })
            
        } else if status == StatusType.running.title {
            
            resultData = studyGoals.filter({
                
                let isRunning = $0.studyPeriod.startDate > Date().timeIntervalSince1970
                
                let isStartDoing = $0.studyItems.allSatisfy({ $0.isCompleted == true })
                
                let isDoing = $0.studyItems.allSatisfy({ $0.isCompleted == false })
                
                return (isStartDoing || isDoing && isRunning) ? false : true

            })
            
        } else {
            
            resultData = studyGoals.filter({ $0.studyItems.allSatisfy({ $0.isCompleted == true }) })

        }
        
        return resultData
        
    }
    
}

extension StudyGoalViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return studyGoals.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studyGoals[section].studyItems.count + 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TopTableViewCell.self), for: indexPath)

            guard let cell = cell as? TopTableViewCell else { return cell }
            
            cell.showStudyGoalHeader(studyGoal: studyGoals[indexPath.section], isCalendar: false)
            
        } else if indexPath.row - 1 < studyGoals[indexPath.section].studyItems.count {
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: StudyGoalTableViewCell.self), for: indexPath)

            guard let cell = cell as? StudyGoalTableViewCell else { return cell }
            
            cell.checkButton.addTarget(self, action: #selector(checkItemButton), for: .touchUpInside)
            
            cell.checkIsCompleted(isCompleted: studyGoals[indexPath.section].studyItems[indexPath.row - 1].isCompleted)

            cell.showStudyItem(studyItem: studyGoals[indexPath.section].studyItems[indexPath.row - 1])
            
        } else {
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: BottomTableViewCell.self), for: indexPath)

            guard let cell = cell as? BottomTableViewCell else { return cell }
            
            cell.showStudyGoalBottom(studyGoal: studyGoals[indexPath.section])
            
            cell.deleteButton.addTarget(self, action: #selector(deleteStudyGoalButton), for: .touchUpInside)
            
        }
        
        cell.selectionStyle = .none
        
        return cell
        
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
    
    @objc func checkItemButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: studyGoalTableView)
        
        guard let indexPath = studyGoalTableView.indexPathForRow(at: point) else { return }
        
        handleStudyItemComplete(selectButton: sender, section: indexPath.section, row: indexPath.row)
        
        handleStudyItemFinish(section: indexPath.section, row: indexPath.row)
        
    }
    
    func deleteStudyGoal(section: Int) {
        
        studyGoalManager.deleteData(studyGoal: studyGoals[section])
        
        studyGoals.remove(at: section)
        
        let indexSet = NSMutableIndexSet()
        
        indexSet.add(section)

        studyGoalTableView.deleteSections(indexSet as IndexSet, with: UITableView.RowAnimation.left)
        
    }
    
    func handleStudyItemComplete(selectButton: UIButton, section: Int, row: Int) {
        
        guard var user = user else { return }
        
        if selectButton.tintColor?.cgColor == UIColor.clear.cgColor {
            
            selectButton.tintColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
            
            studyGoals[section].studyItems[row - 1].isCompleted = true
            
            user.achievement.experienceValue += 50

        } else {
            
            selectButton.tintColor = UIColor.clear
            
            studyGoals[section].studyItems[row - 1].isCompleted = false
            
            user.achievement.experienceValue -= 50

        }
        
        studyGoalManager.updateData(studyGoal: studyGoals[section])
        
    }
    
    func handleStudyItemFinish(section: Int, row: Int) {
        
        guard var user = user else { return }
        
        let studyGoalsID = user.achievement.completionGoals
        
        if studyGoals[section].studyItems.allSatisfy({ $0.isCompleted == true}) {
            
            HUD.flash(.labeledSuccess(title: "學習項目完成！", subtitle: nil))
            
            if studyGoalsID.filter({ $0 == studyGoals[section].id }).isEmpty {
                
                user.achievement.completionGoals.append(studyGoals[section].id)
                
            }
            
        } else {
            
            if !studyGoalsID.filter({ $0 == studyGoals[section].id }).isEmpty {
                
                let deleteIndex = studyGoalsID.getArrayIndex(studyGoals[section].id)[0]
                
                user.achievement.completionGoals.remove(at: deleteIndex)
                
            }
            
        }
        
        userManager.updateData(user: user)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            pushToPlanStudyGoalPage(studyGoal: studyGoals[indexPath.section])
            
        }
        
    }
    
}

// MARK: - set StudyGoal page UI style
extension StudyGoalViewController {
    
    func registerTableViewCell() {
        
        studyGoalTableView.register(
            UINib(nibName: String(describing: TopTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: TopTableViewCell.self))
        
        studyGoalTableView.register(
            UINib(nibName: String(describing: StudyGoalTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: StudyGoalTableViewCell.self))
        
        studyGoalTableView.register(
            UINib(nibName: String(describing: BottomTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: BottomTableViewCell.self))
        
    }
    
    func setSelectLineView() {
        
        let viewWidth = UIScreen.main.bounds.width / CGFloat(3.0)
        
        selectLineView.frame = CGRect(x: viewWidth, y: 0, width: viewWidth, height: underlineView.frame.height)
        
        underlineView.addSubview(selectLineView)
        
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
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightGary.hexText)
        
        addGoalButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        addGoalButton.tintColor = UIColor.white
        
        studyGoalTableView.backgroundColor = UIColor.clear
        
        selectStatusColorButton(selectButton: statusButton[1])
        
        studyGoalBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightGary.hexText)
        
        underlineView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        selectLineView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        headerAnimationView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText)
        
        lottieAnimation.backgroundColor = UIColor.clear
        
        lottieAnimation.contentMode = .scaleAspectFit
        
    }
    
    func selectStatusColorButton(selectButton: UIButton) {
        
        _ = statusButton.map({ $0.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.lightBlue.hexText) })
        
        _ = statusButton.map({ $0.tintColor = UIColor.hexStringToUIColor(hex: ColorChart.blue.hexText) })
        
        selectButton.tintColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
    }
    
}
