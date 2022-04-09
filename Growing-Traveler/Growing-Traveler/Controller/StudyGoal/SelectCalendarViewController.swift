//
//  SelectCalenderViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit
import FSCalendar

class SelectCalendarViewController: UIViewController {
    
    var calendar = FSCalendar()
    
    var getSelectDate: ((_ date: Date) -> Void)?
    
    var startDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalenderFrame()
        
        view.backgroundColor = UIColor.white
        
        // 左右滑動
        calendar.scrollDirection = .horizontal
        
        // 修改 weekendColor
        calendar.appearance.titleWeekendColor = UIColor.lightGray

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendar.delegate = self
        
        calendar.dataSource = self
    }

    func setCalenderFrame() {
        
        view.addSubview(calendar)
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            calendar.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9),
            calendar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9)
        ])
        
    }

}

extension SelectCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: - Calendar DataSource
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        
        return startDate
        
    }
    
    // MARK: - Calendar Delegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        getSelectDate?(date)
        
        self.view.removeFromSuperview()
        
    }
    
}
