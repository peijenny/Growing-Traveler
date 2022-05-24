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
    
    var selectDate: Date?
    
    var startDate: Date? {
        
        didSet {
            
            calendarView.delegate = self
            
            calendarView.dataSource = self
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "日期篩選"
        
        view.backgroundColor = UIColor.white
        
        setCalenderFrame()
        
        setCalendarStyle()
        
        setNavigationBar()
        
    }
    
    func setNavigationBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(selectDateButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(setClosePageButton))
        
    }
    
    @objc func setClosePageButton(sender: UIButton) {
        
        dismiss(animated: true, completion: .none)
        
    }
    
    @objc func selectDateButton(sender: UIButton) {
        
        if let selectDate = selectDate {
            
            getSelectDate?(selectDate)
            
            dismiss(animated: true, completion: .none)
            
        } else {
            
            HandleInputResult.selectDate.messageHUD
            
        }
        
    }

}

extension SelectCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: - Calendar DataSource
    func minimumDate(for calendar: FSCalendar) -> Date {
        
        return startDate ?? Date()
        
    }
    
    // MARK: - Calendar Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        selectDate = date
        
    }
    
}

extension SelectCalendarViewController {
 
    func setCalenderFrame() {
        
        view.addSubview(calendarView)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            calendarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            calendarView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
        ])
        
    }
    
    func setCalendarStyle() {
        
        // MARK: - calendar scroll direction
        calendarView.scrollDirection = .horizontal
        
        // MARK: - modify calendar weekendColor
        calendarView.appearance.titleWeekendColor = UIColor.lightGray
        
        calendarView.appearance.headerTitleColor = UIColor.hexStringToUIColor(
            hex: ColorChat.darkBlue.hexText)
        
        calendarView.appearance.weekdayTextColor = UIColor.hexStringToUIColor(
            hex: ColorChat.darkBlue.hexText)
        
        calendarView.appearance.todayColor = UIColor.clear
        
        calendarView.appearance.titleTodayColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        calendarView.appearance.selectionColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
    }
    
}
