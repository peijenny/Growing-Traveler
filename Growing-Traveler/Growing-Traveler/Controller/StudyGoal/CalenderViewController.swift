//
//  CalenderViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/12.
//

import UIKit
import FSCalendar

class CalenderViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}

extension CalenderViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: - Calendar DataSource
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        
        return Date()
        
    }
    
    // MARK: - Calendar Delegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // 顯示 Calender 的日期，顯示出當日需要學習的目標
        
    }
    
}

extension CalenderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
    
}
