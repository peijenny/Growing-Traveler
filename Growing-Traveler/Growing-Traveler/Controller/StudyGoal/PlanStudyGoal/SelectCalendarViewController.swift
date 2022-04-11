//
//  SelectCalenderViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit
import FSCalendar

class SelectCalendarViewController: UIViewController {
    
    var calendarView = FSCalendar()
    
    var getSelectDate: ((_ date: Date) -> Void)?
    
    var startDate: Date? {
        
        didSet {
            
            calendarView.delegate = self
            
            calendarView.dataSource = self
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "日期篩選"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(setClosePageButton)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        setCalenderFrame()
        
        view.backgroundColor = UIColor.white
        
        // 左右滑動
        calendarView.scrollDirection = .horizontal
        
        // 修改 weekendColor
        calendarView.appearance.titleWeekendColor = UIColor.lightGray

    }
    
    @objc func setClosePageButton() {
        
        dismiss(animated: true, completion: .none)
        
    }

    func setCalenderFrame() {
        
        view.addSubview(calendarView)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            calendarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            calendarView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
        
    }

}

extension SelectCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: - Calendar DataSource
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        
        return startDate ?? Date()
        
    }
    
    // MARK: - Calendar Delegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        getSelectDate?(date)
        
        dismiss(animated: true, completion: .none)
        
    }
    
}
