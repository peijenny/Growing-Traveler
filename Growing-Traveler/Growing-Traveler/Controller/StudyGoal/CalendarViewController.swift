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
            forCellReuseIdentifier: String(describing: TopTableViewCell.self)
        )
        
        calendarView.appearance.titleWeekendColor = UIColor.lightGray
        
        calendarView.appearance.todayColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        calendarView.appearance.titleTodayColor = UIColor.white
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        listenData()
        
        if userID == "" {
            
            displayBackgroundView.isHidden = false
            
        }
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func listenData() {
 
        studyGoalManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.studyGoals = data.filter({
                    
                    let startDate = $0.studyPeriod.startDate

                    let selectDate = strongSelf.selectedDate.timeIntervalSince1970

                    let endDate = $0.studyPeriod.endDate
                    
                    if startDate <= selectDate && endDate >= selectDate {
                        
                        return true
                        
                    }
                    
                    return false
                    
                })

                if strongSelf.studyGoals.count == 0 {
                    
                    strongSelf.displayBackgroundView.isHidden = false

                } else {

                    strongSelf.displayBackgroundView.isHidden = true

                }
                
                strongSelf.displayTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }

}

// MARK: - FSCalendar Delegate / DataSource
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: - Calendar DataSource
    
//    func minimumDate(for calendar: FSCalendar) -> Date {
//
//        return Date()
//
//    }
    
    // MARK: - Calendar Delegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendarView.appearance.todayColor = UIColor.clear
        
        calendarView.appearance.titleTodayColor = UIColor.hexStringToUIColor(hex: ColorChart.darkBlue.hexText)
        
        selectedDate = date
        
        listenData()
        
    }
    
}

// MARK: - TableView DataSource
extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studyGoals.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TopTableViewCell.self),
            for: indexPath
        )

        guard let cell = cell as? TopTableViewCell else { return cell }
        
        cell.selectionStyle = .none
        
        cell.showStudyGoalHeader(studyGoal: studyGoals[indexPath.row], isCalendar: true)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = UIStoryboard
            .studyGoal
            .instantiateViewController(
            withIdentifier: String(describing: PlanStudyGoalViewController.self)
        )

        guard let viewController = viewController as? PlanStudyGoalViewController else { return }

        viewController.studyGoal = studyGoals[indexPath.row]

        viewController.selectedDate = selectedDate

        viewController.getSelectedDate = { selectedDate in

            self.selectedDate = selectedDate

            self.listenData()

        }

        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
