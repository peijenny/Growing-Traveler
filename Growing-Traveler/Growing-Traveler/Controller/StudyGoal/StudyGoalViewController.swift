//
//  StudyGoalViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit
import PKHUD
import Lottie
import Firebase

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
            
            // MARK: - long Press tableView cell -> push userInfo page
            let longPressRecognizer = UILongPressGestureRecognizer(
                target: self, action: #selector(longPressed(sender:)))
            
            studyGoalTableView.addGestureRecognizer(longPressRecognizer)
            
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
        
        // MARK: - login out and not login behavior
        if userID == "" {
            
            studyGoalBackgroundView.isHidden = false
            
            studyGoals = []
            
            studyGoalTableView.reloadData()
            
        }
        
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
        
        selectLineView.frame = CGRect(
            x: viewWidth, y: 0, width: viewWidth, height: underlineView.frame.height)
        
        selectLineView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        underlineView.addSubview(selectLineView)
        
    }
    
    func setHeaserLottieView() {
        
        lottieAnimation = AnimationView(name: "101546-study-abroad")
        
        lottieAnimation.backgroundColor = UIColor.clear
        
        let size = headerAnimationView.frame.height * CGFloat(0.8) - 30
        
        lottieAnimation.contentMode = .scaleAspectFit

        headerAnimationView.addSubview(lottieAnimation)
        
        lottieAnimation.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lottieAnimation.centerXAnchor.constraint(equalTo: headerAnimationView.centerXAnchor),
            lottieAnimation.centerYAnchor.constraint(equalTo: headerAnimationView.centerYAnchor, constant: 50),
            lottieAnimation.widthAnchor.constraint(equalToConstant: size),
            lottieAnimation.heightAnchor.constraint(equalToConstant: size)
        ])

        lottieAnimation.loopMode = .loop

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

    func pushToPlanStudyGoalPage(studyGoal: StudyGoal?) {
        
        let viewController = UIStoryboard.studyGoal.instantiateViewController(
            withIdentifier: String(describing: PlanStudyGoalViewController.self))
        
        guard let viewController = viewController as? PlanStudyGoalViewController else { return }
        
        viewController.studyGoal = studyGoal
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func listenData(status: String) {
        
        studyGoalManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.studyGoals = strongSelf.handleSelectStudyGoals(status: status, studyGoals: data)
                
                if strongSelf.studyGoals.isEmpty {
                    
                    strongSelf.studyGoalBackgroundView.isHidden = false
                    
                } else {
                    
                    strongSelf.studyGoalBackgroundView.isHidden = true
                    
                }
                
                strongSelf.studyGoalTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func handleSelectStudyGoals(status: String, studyGoals: [StudyGoal]) -> [StudyGoal] {
        
        var resultData: [StudyGoal] = []
        
        if status == StatusType.pending.title {

            resultData = studyGoals.filter({
                
                let isPending = $0.studyPeriod.startDate > Date().timeIntervalSince1970
                
                let notStartDoing = $0.studyItems.allSatisfy({ $0.isCompleted == false })
                
                return notStartDoing && isPending ? true : false
                
            })
            
        } else if status == StatusType.running.title {
            
            resultData = studyGoals.filter({
                
                let isRunning = $0.studyPeriod.startDate > Date().timeIntervalSince1970
                
                let isStartDoing = $0.studyItems.allSatisfy({ $0.isCompleted == true })
                
                let isDoing = $0.studyItems.allSatisfy({ $0.isCompleted == false })
                
                return isStartDoing || isDoing && isRunning ? false : true

            })
            
        } else {
            
            resultData = studyGoals.filter({ $0.studyItems.allSatisfy({ $0.isCompleted == true }) })

        }
        
        return resultData
        
    }
    
    @IBAction func handleStatusButton(_ sender: UIButton) {
        
        if userID == "" {
            
            studyGoals.removeAll()
            
            studyGoalTableView.reloadData()
            
            studyGoalTableView.isHidden = false
            
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in

            guard let strongSelf = self else { return }
            
            strongSelf.selectLineView.frame.origin.x = sender.frame.origin.x
            
        })
        
        _ = statusButton.map({ $0.tintColor = UIColor.hexStringToUIColor(hex: ColorChart.blue.hexText) })
        
        sender.tintColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        guard let titleText = sender.titleLabel?.text else { return }
        
        listenData(status: "\(titleText)")
        
        self.titleText = titleText
        
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
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TopTableViewCell.self), for: indexPath)

            guard let cell = cell as? TopTableViewCell else { return cell }
            
            cell.selectionStyle = .none
            
            cell.showStudyGoalHeader(studyGoal: studyGoals[indexPath.section], isCalendar: false)
            
            return cell
            
        } else if indexPath.row - 1 < studyGoals[indexPath.section].studyItems.count {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: StudyGoalTableViewCell.self), for: indexPath)

            guard let cell = cell as? StudyGoalTableViewCell else { return cell }
            
            cell.selectionStyle = .none
            
            cell.checkButton.addTarget(
                self, action: #selector(checkItemButton), for: .touchUpInside)
            
            let isCompleted = studyGoals[indexPath.section].studyItems[indexPath.row - 1].isCompleted
            
            cell.checkIsCompleted(isCompleted: isCompleted)
            
            let studyItem = studyGoals[indexPath.section].studyItems[indexPath.row - 1]
            
            cell.showStudyItem(studyItem: studyItem)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: BottomTableViewCell.self), for: indexPath)

            guard let cell = cell as? BottomTableViewCell else { return cell }
            
            cell.selectionStyle = .none
            
            cell.showStudyGoalBottom(studyGoal: studyGoals[indexPath.section])
            
            return cell
            
        }
        
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.studyGoalTableView)
            
            if let indexPath = studyGoalTableView.indexPathForRow(at: touchPoint) {
                
                let alertController = UIAlertController(
                    title: "刪除個人學習計劃", message: "請問確定刪除此計劃嗎？\n 刪除行為不可逆，將無法再瀏覽此計劃！",
                    preferredStyle: .alert)
                
                let agreeAction = UIAlertAction(title: "確認", style: .destructive) { [weak self] _ in
                    
                    guard let strongSelf = self else { return }
                    
                    strongSelf.studyGoalManager.deleteData(studyGoal: strongSelf.studyGoals[indexPath.section])
                    
                    strongSelf.studyGoals.remove(at: indexPath.section)
                    
                    strongSelf.studyGoalTableView.beginUpdates()
                    
                    let indexSet = NSMutableIndexSet()
                    
                    indexSet.add(indexPath.section)

                    strongSelf.studyGoalTableView.deleteSections(
                        indexSet as IndexSet, with: UITableView.RowAnimation.left)

                    strongSelf.studyGoalTableView.endUpdates()
                    
                }
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel)
                
                alertController.addAction(agreeAction)
                
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)

            }
            
        }
        
    }
    
    @objc func checkItemButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: studyGoalTableView)

        if let indexPath = studyGoalTableView.indexPathForRow(at: point) {
            
            guard var user = user else { return }

            if sender.tintColor?.cgColor == UIColor.clear.cgColor {
                
                sender.tintColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
                
                studyGoals[indexPath.section].studyItems[indexPath.row - 1].isCompleted = true
                
                user.achievement.experienceValue += 50

            } else {
                
                sender.tintColor = UIColor.clear
                
                studyGoals[indexPath.section].studyItems[indexPath.row - 1].isCompleted = false
                
                user.achievement.experienceValue -= 50

            }
            
            studyGoalManager.updateData(studyGoal: studyGoals[indexPath.section])
            
            if studyGoals[indexPath.section].studyItems.allSatisfy({ $0.isCompleted == true}) {
                
                HUD.flash(.labeledSuccess(title: "學習項目完成！", subtitle: nil))
                
                if user.achievement.completionGoals.filter({ $0 == studyGoals[indexPath.section].id }).isEmpty {
                    
                    user.achievement.completionGoals.append(studyGoals[indexPath.section].id)
                    
                }
                
            } else {
                
                if !user.achievement.completionGoals.filter({ $0 == studyGoals[indexPath.section].id }).isEmpty {
                    
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
        
        pushToPlanStudyGoalPage(studyGoal: studyGoals[indexPath.section])
        
    }
    
}
