//
//  CalenderViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/12.
//

import UIKit
import FSCalendar
import PKHUD

class CalendarViewController: UIViewController {
    
    // MARK: - IBOutlet / Components
    @IBOutlet weak var calendarView: FSCalendar! {
        
        didSet {
            
            calendarView.delegate = self
            
            calendarView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var displayTableView: UITableView! {
        
        didSet {
            
            displayTableView.delegate = self
            
            displayTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var displayBackgroundView: UIView!
    
    @IBOutlet weak var calendarBackgroundView: UIView!
    
    // MARK: - Property
    var studyGoalManager = StudyGoalManager()
    
    var studyGoals: [StudyGoal] = [] {
        
        didSet {
            
            displayTableView.reloadData()
            
        }
        
    }
    
    var selectedDate = Date()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIStyle()
        
        registerTableViewCell()
        
        showSelectedDateData()

        listenStudyGoalData()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    // MARK: - Set UI and default data
    func setUIStyle() {
        
        title = "成長日曆"
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        calendarBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
        calendarView.appearance.titleWeekendColor = UIColor.lightGray
        
        calendarView.appearance.todayColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        calendarView.appearance.titleTodayColor = UIColor.white
        
        if KeyToken().userID == "" {
            
            displayBackgroundView.isHidden = false
        
        } else {
            
            displayBackgroundView.isHidden = true
        
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    func registerTableViewCell() {
        
        displayTableView.register(
            UINib(nibName: String(describing: TopTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: TopTableViewCell.self))
        
    }
    
    func showSelectedDateData() {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        selectedDate = formatter.date(from: formatter.string(from: Date())) ?? Date()
        
    }
    
    // MARK: - Method
    func listenStudyGoalData() {
 
        studyGoalManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.studyGoals = strongSelf.handleStudyGoal(studyGoals: data)

                strongSelf.displayTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func handleStudyGoal(studyGoals: [StudyGoal]) -> [StudyGoal] {
        
        let resultData = studyGoals.filter({
            
            let lessEqualStartDate = $0.studyPeriod.startDate <= selectedDate.timeIntervalSince1970
            
            let greaterEqualEndDate = $0.studyPeriod.endDate >= selectedDate.timeIntervalSince1970
            
            return (lessEqualStartDate && greaterEqualEndDate) ? true : false
            
        })
        
        displayBackgroundView.isHidden = (resultData.isEmpty) ? false : true
        
        return resultData
        
    }

}

// MARK: - calendar delegate / dataSource
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendarView.appearance.todayColor = UIColor.clear
        
        calendarView.appearance.titleTodayColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        selectedDate = date
        
        listenStudyGoalData()
        
    }
    
}

// MARK: - tableView delegate / dataSource
extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return studyGoals.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TopTableViewCell.self), for: indexPath)

        guard let cell = cell as? TopTableViewCell else { return cell }
        
        cell.selectionStyle = .none
        
        cell.showStudyGoalHeader(studyGoal: studyGoals[indexPath.section], isCalendar: true)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = UIStoryboard.studyGoal.instantiateViewController(
            withIdentifier: String(describing: PlanStudyGoalViewController.self))

        guard let viewController = viewController as? PlanStudyGoalViewController else { return }

        viewController.studyGoal = studyGoals[indexPath.section]

        viewController.selectedDate = selectedDate

        viewController.getSelectedDate = { [weak self] selectedDate in

            guard let strongSelf = self else { return }
            
            strongSelf.selectedDate = selectedDate

            strongSelf.listenStudyGoalData()

        }

        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
