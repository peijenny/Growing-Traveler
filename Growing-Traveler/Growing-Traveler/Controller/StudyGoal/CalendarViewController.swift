//
//  CalenderViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/12.
//

import UIKit
import FSCalendar

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
    
    var studyGoalManager = StudyGoalManager()
    
    var studyGoals: [StudyGoal] = []
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "成長日曆"
        
        displayTableView.register(
            UINib(nibName: String(describing: StudyGoalHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: StudyGoalHeaderView.self)
        )
        
        fetchData(date: Date())
        
        calendarView.appearance.titleWeekendColor = UIColor.lightGray
        
    }
    
    func fetchData(date: Date) {
        
        studyGoals.removeAll()
        
        studyGoalManager.fetchData(completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.formatter.dateFormat = "yyyy.MM.dd"
                
                strongSelf.studyGoals = data.filter({
                    
                    let startDate = strongSelf.formatter.string(from: $0.studyPeriod.startTime)

                    let selectDate = strongSelf.formatter.string(from: date)

                    let endDate = strongSelf.formatter.string(from: $0.studyPeriod.endTime)
                    
                    if startDate >= selectDate || endDate >= selectDate {
                        
                        return true
                        
                    }
                    
                    return false
                    
                })
                
                print("TEST \(strongSelf.studyGoals.count)")
                
                strongSelf.displayTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
            }
            
        })
        
    }

}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: - Calendar DataSource
    
    func minimumDate(for calendar: FSCalendar) -> Date {

        return Date()

    }
    
    // MARK: - Calendar Delegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        fetchData(date: date)
        
    }
    
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return studyGoals.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: StudyGoalHeaderView.self))

        guard let headerView = headerView as? StudyGoalHeaderView else { return headerView }
        
        headerView.studyGoalTitleLabel.text = studyGoals[section].title
        
        headerView.endDateLabel.text = formatter.string(
            from: studyGoals[section].studyPeriod.endTime)
        
        return headerView
        
    }
    
}
