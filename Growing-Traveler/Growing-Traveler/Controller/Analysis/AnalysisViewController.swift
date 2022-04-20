//
//  AnalysisViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/20.
//

import UIKit
import Charts

class AnalysisViewController: UIViewController {

    @IBOutlet weak var analysisBarChatView: BarChartView!
    
    @IBOutlet weak var testLabel: UILabel!
    
    // 測試顯示資料
    var sevenDaysArray: [String] = []
    
    var calculateStudyTime: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    var axisFormatDelgate: AxisValueFormatter?
    
    var analysisManager = AnalysisManager()
    
    var studyGoals: [StudyGoal] = []
    
    var calculates: [Calculate] = []
    
    let day = 24 * 60 * 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
    }
    
    func fetchData() {
        
        analysisManager.fetchData { [weak self] result in
            
            switch result {
                
            case .success(let studyGoals):
                
                self?.studyGoals = studyGoals
                
                self?.handleData()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
    }
    
    func handleData() {
        
        let yesterday = Date().addingTimeInterval(-Double((day))).addingTimeInterval(Double(day / 3))
        
        let sevenDaysAgo = Date().addingTimeInterval(-Double((day * 7))).addingTimeInterval(Double(day / 3))
        
        handleSevenDays(yesterday: yesterday)
        
        for goalIndex in 0..<studyGoals.count {
            
            var totalMinutes = 0
            
            var includedDays = 0
            
            var includedArray: [Included] = []
            
            let startDate = Date(
                timeIntervalSince1970: studyGoals[goalIndex].studyPeriod.startDate).addingTimeInterval(Double(day))
            
            let endDate = Date(
                timeIntervalSince1970: studyGoals[goalIndex].studyPeriod.endDate).addingTimeInterval(Double(day))
            
            for index in 0..<studyGoals[goalIndex].studyItems.count {
                
                if studyGoals[goalIndex].studyItems[index].isCompleted == true {
                    
                    totalMinutes += studyGoals[goalIndex].studyItems[index].studyTime
                    
                }
                
            }
            
            let periodDays = checkDiff(start: startDate, end: endDate)
            
            let averageTime = totalMinutes / periodDays
            
            if startDate >= sevenDaysAgo && startDate <= yesterday {
                
                includedDays = checkDiff(start: startDate, end: yesterday)
                
                for index in 0..<sevenDaysArray.count {
                    
                    let studyDate = sevenDaysAgo.addingTimeInterval(Double(day * index))
                    
                    let studyTime = (startDate <= sevenDaysAgo.addingTimeInterval(Double(day * index))) ? averageTime: 0
                    
                    includedArray.append(Included(day: studyDate, time: studyTime))
                    
                }

            } else if endDate >= sevenDaysAgo && endDate <= yesterday {
                
                includedDays = checkDiff(start: sevenDaysAgo, end: endDate)
                
                for index in 0..<sevenDaysArray.count {
                    
                    let studyDate = sevenDaysAgo.addingTimeInterval(Double(day * index))
                    
                    let studyTime = endDate >= sevenDaysAgo.addingTimeInterval(Double(day * index)) ? averageTime: 0
                    
                    includedArray.append(Included(day: studyDate, time: studyTime))
                    
                }
                
            } else {

                includedDays = 7
                
                for index in 0..<includedDays {
                    
                    let studyDate = sevenDaysAgo.addingTimeInterval(Double(day * index))
                    
                    let studyTime = averageTime
                    
                    includedArray.append(Included(day: studyDate, time: studyTime))
                    
                }

            }
            
            calculates.append(Calculate(
                startDate: startDate, endDate: endDate, periodDays: periodDays, totalMinutes: totalMinutes,
                averageMinutes: averageTime, includedDays: includedDays, included: includedArray))
            
        }
        
        calculateSevenDayStudyTime()

    }
    
    func handleSevenDays(yesterday: Date) {
        
        for index in 0..<7 {
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "MM.dd"
            
            let displayDay = formatter.string(from: yesterday.addingTimeInterval(Double(day * index)))
            
            sevenDaysArray.append(displayDay)
            
        }
        
    }
    
    func calculateSevenDayStudyTime() {
        
        for calculateIndex in 0..<calculates.count {
            
            for index in 0..<calculates[calculateIndex].included.count {
                
                calculateStudyTime[index] += Double(calculates[calculateIndex].included[index].time) / 60.0
                
            }
                
        }

        updateChatsData()
    }
    
    func checkDiff(start: Date, end: Date) -> Int {
        
        let formatter = DateFormatter()
        
        let calendar = Calendar.current
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = formatter.date(from: formatter.string(from: start))
        
        let endDate = formatter.date(from: formatter.string(from: end))
        
        if let startDate = startDate, let endDate = endDate {
            
            let diff: DateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
            
            return (diff.day ?? 0) + 1
            
        }
        
        return 0
        
    }
    
    func updateChatsData() {
        
        // 存放資料的陣列，型態為 BarChartDataEntry
        var dataEntries: [BarChartDataEntry] = []
        
        // 使用迴圈將資料加入存放資料的陣列中
        for index in 0..<calculateStudyTime.count {
            
            // 設定 x, y 座標要顯示的東西有哪些
            let dataEntry = BarChartDataEntry(x: Double(index), y: calculateStudyTime[index])
            
            // 將資料加入到陣列中
            dataEntries.append(dataEntry)
            
        }
        
        // 設定 BarChartDataSet 設定要顯示的資料是什麼，以及圖表下方的 Label
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Last Sevent day")
        
        chartDataSet.colors = ChartColorTemplates.colorful()
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        analysisBarChatView.data = chartData
        
        analysisBarChatView.xAxis.valueFormatter = IndexAxisValueFormatter(values: sevenDaysArray)
        
        analysisBarChatView.xAxis.granularity = 1
        
    }

}
