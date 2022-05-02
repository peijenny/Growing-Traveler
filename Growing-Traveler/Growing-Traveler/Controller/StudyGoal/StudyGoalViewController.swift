//
//  StudyGoalViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit
import PKHUD
import Lottie

enum StatusType {
    
    case pending
    
    case running
    
    case finished
    
    var title: String {
        
        switch self {
            
        case .pending: return "待處理"
            
        case .running: return "處理中"
            
        case .finished: return "已處理"
            
        }
    }
}

class StudyGoalViewController: UIViewController {
    
    @IBOutlet weak var studyGoalTableView: UITableView! {
        
        didSet {
            
            studyGoalTableView.delegate = self
            
            studyGoalTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var addGoalButton: UIButton!
    
    @IBOutlet var statusButton: [UIButton]!
    
    var studyGoalManager = StudyGoalManager()
    
    var userManager = UserManager()
    
    var user: UserInfo?
    
    var studyGoals: [StudyGoal] = []
    
    var titleText = StatusType.running.title
    
    var topCGFloat = CGFloat()
    
    var bottomCGFloat = CGFloat()
    
    @IBOutlet weak var underlineView: UIView!
    
    var selectLineView = UIView()
    
    @IBOutlet weak var headerAnimationView: UIView!
    
    @IBOutlet weak var studyGoalBackgroundView: UIView!
    
    var lottieAnimation = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - 註冊 TableView header / footer / cell
        studyGoalTableView.register(
            UINib(nibName: String(describing: StudyGoalHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: StudyGoalHeaderView.self)
        )
        
        studyGoalTableView.register(
            UINib(nibName: String(describing: StudyGoalFooterView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: StudyGoalFooterView.self)
        )
        
        studyGoalTableView.register(
            UINib(nibName: String(describing: StudyGoalTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: StudyGoalTableViewCell.self)
        )
        
        listenData(status: StatusType.running.title)
        
        // MARK: - 右上角的 成長日曆 Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.timetable),
            style: .plain, target: self,
            action: #selector(pushToCalenderPage)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        fetchUserData()
        
        setHeaserLottieView()
        
        setSelectLineView()
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lottieAnimation.play()
        
        tabBarController?.tabBar.isHidden = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // MARK: - 右下角 新增個人學習計劃 Button 修改圖片的顯示方式與加上圓角
        addGoalButton.imageView?.contentMode = .scaleAspectFill

        addGoalButton.layer.cornerRadius = addGoalButton.frame.width / 2
        
    }
    
    func setSelectLineView() {
        
        let viewWidth = UIScreen.main.bounds.width / CGFloat(3.0)
        
        selectLineView.frame = CGRect(
            x: viewWidth, y: 0,
            width: viewWidth,
            height: underlineView.frame.height
        )
        
        selectLineView.backgroundColor = UIColor.hexStringToUIColor(hex: "0384BD")
        
        underlineView.addSubview(selectLineView)
        
    }
    
    func setHeaserLottieView() {
        
        lottieAnimation = AnimationView(name: "Growth-Animation")
        
        lottieAnimation.contentMode = .scaleAspectFit
        
        lottieAnimation.frame = CGRect(
            x: 0, y: 30,
            width: headerAnimationView.frame.width,
            height: headerAnimationView.frame.height
        )
        
//        lottieAnimation.center = headerAnimationView.center
        
        headerAnimationView.addSubview(lottieAnimation)
        
        lottieAnimation.loopMode = .loop
        
//        lottieAnimation.play()

    }
    
    func fetchUserData() {
        
        userManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let user):
                
                strongSelf.user = user

                let date = Date()

                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy.MM.dd"

                let today = dateFormatter.string(from: date)

                guard var user = strongSelf.user else { return }
                
                if user.achievement.loginDates.filter({ $0 == today }).count == 0 {
                    
                    user.achievement.loginDates.append(today)
                    
                    strongSelf.userManager.updateData(user: user)
                    
                }
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }

    // MARK: - 跳轉到成長日曆頁面
    @objc func pushToCalenderPage(sender: UIButton) {
        
        let viewController = UIStoryboard(
            name: "StudyGoal",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: String(describing: CalendarViewController.self)
        )
        
        guard let viewController = viewController as? CalendarViewController else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    // MARK: - 新增個人學習計劃 Button
    @IBAction func addStudyGoalButton(_ sender: UIButton) {
        
        guard userID != "" else {
            
            guard let authViewController = UIStoryboard.auth.instantiateViewController(
                    withIdentifier: String(describing: AuthenticationViewController.self)
                    ) as? AuthenticationViewController else { return }
            
            authViewController.modalPresentationStyle = .popover

            present(authViewController, animated: true, completion: nil)
            
            return
        }
        
        pushToPlanStudyGoalPage(studyGoal: nil)
        
    }
    
    // MARK: - 跳轉到個人學習計劃 Button (新增 / 修改)
    func pushToPlanStudyGoalPage(studyGoal: StudyGoal?) {
        
        let viewController = UIStoryboard(
            name: "StudyGoal",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: String(describing: PlanStudyGoalViewController.self)
        )
        
        guard let viewController = viewController as? PlanStudyGoalViewController else { return }
        
        viewController.studyGoal = studyGoal
        
        viewController.user = user
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    // MARK: - 即時監聽 Firestore 的個人學習計畫
    func listenData(status: String) {
        
        studyGoalManager.fetchData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                var resultData: [StudyGoal] = []
                
                let formatter = DateFormatter()
                
                formatter.dateFormat = "yyyy.MM.dd"
                
                if status == StatusType.pending.title {

                    resultData = data.filter({
                        
                        let startDate = Date(timeIntervalSince1970: $0.studyPeriod.startDate).formatted()
                        
                        let nowDate = Date().formatted()
                        
                        if $0.studyItems.allSatisfy({ $0.isCompleted == false }) == true &&
                            startDate > nowDate {
                                
                                return true
                            
                        }
                        
                        return false

                    })
                    
                } else if status == StatusType.running.title {
                    
                    resultData = data.filter({
                        
                        let startDate = Date(timeIntervalSince1970: $0.studyPeriod.startDate).formatted()
                        
                        let nowDate = Date().formatted()
                        
                        if $0.studyItems.allSatisfy({ $0.isCompleted == true }) == true {
                            
                            return false
                            
                        } else if $0.studyItems.allSatisfy({ $0.isCompleted == false }) == true &&
                                    startDate > nowDate {
                                
                                return false
                            
                        }
                        
                        return true

                    })
                    
                } else if status == StatusType.finished.title {
                    
                    resultData = data.filter({
                        
                        $0.studyItems.allSatisfy({ $0.isCompleted == true })

                    })

                }
                
                strongSelf.studyGoals = resultData
                
                if resultData.count == 0 {
                    
                    strongSelf.studyGoalBackgroundView.isHidden = false
                    
                } else {
                    
                    strongSelf.studyGoalBackgroundView.isHidden = true
                    
                }
                
                strongSelf.studyGoalTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    // MARK: - NavBar 下方的 (待處理 / 處理中 / 已處理) Button
    @IBAction func handleStatusButton(_ sender: UIButton) {
        
        // 動畫
        UIView.animate(withDuration: 0.5, animations: { [weak self] in

            guard let strongSelf = self else { return }
            
            strongSelf.selectLineView.frame.origin.x = sender.frame.origin.x
            
        })
        
        _ = statusButton.map({ $0.tintColor = UIColor.hexStringToUIColor(hex: "69B6CA") })
        
        sender.tintColor = UIColor.hexStringToUIColor(hex: "0384BD")
        
        guard let titleText = sender.titleLabel?.text else { return }
        
        listenData(status: "\(titleText)")
        
        self.titleText = titleText
        
    }
    
}

// MARK: - TableView DataSource
extension StudyGoalViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return studyGoals.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studyGoals[section].studyItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: StudyGoalTableViewCell.self),
            for: indexPath
        )

        guard let cell = cell as? StudyGoalTableViewCell else { return cell }
        
        cell.selectionStyle = .none
        
        cell.checkButton.addTarget(
            self, action: #selector(checkItemButton), for: .touchUpInside)
        
        let isCompleted = studyGoals[indexPath.section].studyItems[indexPath.row].isCompleted
        
        cell.checkIsCompleted(isCompleted: isCompleted)
        
        let studyItem = studyGoals[indexPath.section].studyItems[indexPath.row]
        
        cell.showStudyItem(studyItem: studyItem)
        
        return cell
        
    }
    
    @objc func checkItemButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: studyGoalTableView)

        if let indexPath = studyGoalTableView.indexPathForRow(at: point) {
            
            guard var user = user else { return }

            if sender.tintColor?.cgColor == UIColor.clear.cgColor {
                
                sender.tintColor = UIColor.hexStringToUIColor(hex: "0384BD")
                
                studyGoals[indexPath.section].studyItems[indexPath.row].isCompleted = true
                
                user.achievement.experienceValue += 50

            } else {
                
                sender.tintColor = UIColor.clear
                
                studyGoals[indexPath.section].studyItems[indexPath.row].isCompleted = false
                
                user.achievement.experienceValue -= 50

            }
            
            studyGoalManager.updateData(studyGoal: studyGoals[indexPath.section])
            
            if studyGoals[indexPath.section].studyItems.allSatisfy({ $0.isCompleted == true}) {
                
                HUD.flash(.labeledSuccess(title: "學習項目完成！", subtitle: nil))
                
                if user.achievement.completionGoals.filter({ $0 == studyGoals[indexPath.section].id }).count == 0 {
                    
                    user.achievement.completionGoals.append(studyGoals[indexPath.section].id)
                    
                }
                
            } else {
                
                if user.achievement.completionGoals.filter({ $0 == studyGoals[indexPath.section].id }).count != 0 {
                    
                    var deleteIndex = Int()
                    
                    for index in 0..<user.achievement.completionGoals.count {

                        if user.achievement.completionGoals[index] == studyGoals[indexPath.section].id {

                            deleteIndex = index
                            
                        }

                    }
                    
                    user.achievement.completionGoals.remove(at: deleteIndex)
                    
                }
                
            }
            
            listenData(status: titleText)
            
            userManager.updateData(user: user)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        pushToPlanStudyGoalPage(studyGoal: studyGoals[indexPath.section])
        
    }
    
}

// MARK: - TableView Delegate
extension StudyGoalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: StudyGoalHeaderView.self))

        guard let headerView = headerView as? StudyGoalHeaderView else { return headerView }
        
        headerView.showStudyGoalHeader(studyGoal: studyGoals[section])

        tableView.tableHeaderView = UIView.init(frame: CGRect.init(
            x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height))
        
        topCGFloat = headerView.frame.height
        
        setContentInset()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        headerView.addGestureRecognizer(tapGestureRecognizer)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: StudyGoalFooterView.self))

        guard let footerView = footerView as? StudyGoalFooterView else { return footerView }
        
        footerView.showStudyGoalFooter(studyGoal: studyGoals[section])
        
        tableView.tableFooterView = UIView.init(frame: CGRect.init(
            x: 0, y: 0, width: footerView.frame.width, height: footerView.frame.height))
        
        bottomCGFloat = footerView.frame.height
        
        setContentInset()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        footerView.addGestureRecognizer(tapGestureRecognizer)
        
        footerView.deleteButton.addTarget(
            self, action: #selector(deleteRowButton), for: .touchUpInside)
        
        footerView.deleteButton.tag = section
        
        return footerView
    }
    
    func setContentInset() {
        
        studyGoalTableView.contentInset = UIEdgeInsets.init(
            top: -topCGFloat, left: 0, bottom: -bottomCGFloat, right: 0
        )
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {

        let headerView = sender.view as? StudyGoalHeaderView
        
        let footerView = sender.view as? StudyGoalFooterView
        
        for index in 0..<studyGoals.count {
            
            if sender.view == headerView &&
                headerView?.hideRecordLabel.text == studyGoals[index].id {
                
                pushToPlanStudyGoalPage(studyGoal: studyGoals[index])
                
            }
            
            if sender.view == footerView &&
                footerView?.hideRecordLabel.text == studyGoals[index].id {
                
                pushToPlanStudyGoalPage(studyGoal: studyGoals[index])
                
            }
            
        }
        
    }
    
    @objc func deleteRowButton(_ sender: UIButton) {

        studyGoalManager.deleteData(studyGoal: studyGoals[sender.tag])

        studyGoals.remove(at: sender.tag)

        studyGoalTableView.reloadData()

    }
    
}
