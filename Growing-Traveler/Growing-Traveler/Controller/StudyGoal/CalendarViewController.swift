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
    
    var studyGoalManager = StudyGoalManager()
    
    var studyGoals: [StudyGoal] = [] {
        
        didSet {
            
            displayTableView.reloadData()
            
        }
        
    }
    
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "成長日曆"
        
        displayTableView.register(
            UINib(nibName: String(describing: TopTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: TopTableViewCell.self))
        
        calendarView.appearance.titleWeekendColor = UIColor.lightGray
        
        calendarView.appearance.todayColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        calendarView.appearance.titleTodayColor = UIColor.white
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
           title: "", style: .plain, target: nil, action: nil)
        
        displayBackgroundView.isHidden = userID == "" ? false : true
        
        listenStudyGoalData()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
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
            
            return lessEqualStartDate && greaterEqualEndDate ? true : false
            
        })
        
        displayBackgroundView.isHidden = resultData.isEmpty ? false : true
        
        return resultData
        
    }

}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: - calendar delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendarView.appearance.todayColor = UIColor.clear
        
        calendarView.appearance.titleTodayColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        selectedDate = date
        
        listenStudyGoalData()
        
    }
    
}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studyGoals.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TopTableViewCell.self), for: indexPath)

        guard let cell = cell as? TopTableViewCell else { return cell }
        
        cell.selectionStyle = .none
        
        cell.showStudyGoalHeader(studyGoal: studyGoals[indexPath.row], isCalendar: true)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = UIStoryboard.studyGoal.instantiateViewController(
            withIdentifier: String(describing: PlanStudyGoalViewController.self))

        guard let viewController = viewController as? PlanStudyGoalViewController else { return }

        viewController.studyGoal = studyGoals[indexPath.row]

        viewController.selectedDate = selectedDate

        viewController.getSelectedDate = { [weak self] selectedDate in

            guard let strongSelf = self else { return }
            
            strongSelf.selectedDate = selectedDate

            strongSelf.listenStudyGoalData()

        }

        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
