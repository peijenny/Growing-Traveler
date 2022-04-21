//
//  AnalysisViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/20.
//

import UIKit

class AnalysisViewController: UIViewController {
    
    @IBOutlet weak var analysisTableView: UITableView! {
        
        didSet {
            
            analysisTableView.delegate = self
            
            analysisTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var selectSegmentedControl: UISegmentedControl!
    
    var sevenDaysArray: [String] = []
    
    var calculateStudyTime: [Double] = [] {
        
        didSet {
            
            analysisTableView.reloadData()
            
        }
        
    }
    
    var analysisManager = AnalysisManager()
    
    var categoryManager = CategoryManager()
    
    var studyGoals: [StudyGoal] = []
    
    var calculates: [CalculateBar] = []
    
    var spendStudyItem = CalculateSpendStudyItem(itemsTime: [], itemsTitle: [])
    
    var finishedCalculates: [CalculatePie] = []
    
    let day = 24 * 60 * 60
    
    var certificateText = ""
    
    var interesteText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        analysisTableView.register(
            UINib(nibName: String(describing: AnalysisBarChatTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: AnalysisBarChatTableViewCell.self)
        )
        
        analysisTableView.register(
            UINib(nibName: String(describing: AnalysisPieChartTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: AnalysisPieChartTableViewCell.self)
        )
        
        analysisTableView.register(
            UINib(nibName: String(describing: AnalysisContentTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: AnalysisContentTableViewCell.self)
        )
        
        selectSegmentedControl.addTarget(
            self, action: #selector(selectIndexChanged(_:)), for: .valueChanged)
        
    }
    
    @objc func selectIndexChanged(_ send: UISegmentedControl) {
        
        analysisTableView.reloadData()
        
    }
    
    func fetchData() {

        analysisManager.fetchData { [weak self] result in
            
            switch result {
                
            case .success(let studyGoals):
                
                self?.studyGoals = studyGoals
                
                self?.handlePieChartData()
                
                self?.handleBarChartData()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchData()

    }

    func handlePieChartData() {
        
        spendStudyItem.itemsTime.removeAll()
        
        spendStudyItem.itemsTitle.removeAll()
        
        let finishedStudyGoals = studyGoals.filter({
            
            $0.studyItems.allSatisfy({ $0.isCompleted == true })

        })
        
        for finishedIndex in 0..<finishedStudyGoals.count {
            
            var totalMinutes = 0
            
            for index in 0..<finishedStudyGoals[finishedIndex].studyItems.count {
                
                if studyGoals[finishedIndex].studyItems[index].isCompleted == true {
                    
                    totalMinutes += studyGoals[finishedIndex].studyItems[index].studyTime
                    
                }
                
            }
            
            finishedCalculates.append(
                CalculatePie(totalMinutes: Double(totalMinutes), categoryItem: studyGoals[finishedIndex].category))
            
        }
        
        var allTime: Double = 0
        
        for index in 0..<finishedCalculates.count {
            
            allTime += finishedCalculates[index].totalMinutes
        }
        
        allTime /= 100
        
        for index in 0..<finishedCalculates.count {

            let itemTime = (finishedCalculates[index].totalMinutes / allTime)
            
            spendStudyItem.itemsTime.append(itemTime)
            
            spendStudyItem.itemsTitle.append(finishedCalculates[index].categoryItem.title)
            
        }
        
        handleFeedbackText()

    }
    
    func handleFeedbackText() {
        
        for categoryIndex in 0..<finishedCalculates.count {
            
            interesteText += " ○ " + finishedCalculates[categoryIndex].categoryItem.intereste + "\n"
            
            for index in 0..<finishedCalculates[categoryIndex].categoryItem.certificate.count {
                
                certificateText += " □ " + finishedCalculates[categoryIndex].categoryItem.certificate[index] + "\n"
                
            }
            
        }
        
    }
    
    func handleBarChartData() {
        
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
            
            calculates.append(CalculateBar(
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
        
        for _ in 0..<7 {
            
            calculateStudyTime.append(0.0)
        }
        
        for calculateIndex in 0..<calculates.count {
            
            for index in 0..<calculates[calculateIndex].included.count {
                
                calculateStudyTime[index] += Double(calculates[calculateIndex].included[index].time) / 60.0
                
            }
                
        }

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

}

extension AnalysisViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let select = selectSegmentedControl.titleForSegment(
            at: selectSegmentedControl.selectedSegmentIndex) else { return UITableViewCell() }
         
        if indexPath.row == 0 && select == "近七天學習時間" {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: AnalysisBarChatTableViewCell.self),
                for: indexPath)

            guard let cell = cell as? AnalysisBarChatTableViewCell else { return cell }

            cell.updateChatsData(calculateStudyTime: calculateStudyTime, sevenDaysArray: sevenDaysArray)
            
            return cell
                    
        } else if indexPath.row == 0 && select == "近七天學習類型" {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: AnalysisPieChartTableViewCell.self),
                for: indexPath)

            guard let cell = cell as? AnalysisPieChartTableViewCell else { return cell }
            
            cell.updateChatsData(spendStudyItem: spendStudyItem)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: AnalysisContentTableViewCell.self),
                for: indexPath)

            guard let cell = cell as? AnalysisContentTableViewCell else { return cell }
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 10
            
            paragraphStyle.alignment = .left
            
            let interesteAttributes = NSAttributedString(
                string: interesteText,
                attributes: [ NSAttributedString.Key.paragraphStyle: paragraphStyle,
                              NSAttributedString.Key.font: UIFont(name: "PingFang TC", size: 15.0)! ])
            
            cell.interesteLabel.attributedText = interesteAttributes
            
            if certificateText == "" {
                
                certificateText = "目前暫無推薦考取的證照！"
                
            }
            
            let certificateAttributes = NSAttributedString(
                string: certificateText,
                attributes: [ NSAttributedString.Key.paragraphStyle: paragraphStyle,
                               NSAttributedString.Key.font: UIFont(name: "PingFang TC", size: 15.0)!,
                               NSAttributedString.Key.foregroundColor: UIColor.red ])
            
            cell.certificateLabel.attributedText = certificateAttributes
            
            return cell
            
        }
        
    }
    
}

extension Double {
    
    // 無條件進位
    func ceiling(toDecimal decimal: Int) -> Double {
        
        let numberOfDigits = abs(pow(10.0, Double(decimal)))
        
        if self.sign == .minus {
            
            return Double(Int(self * numberOfDigits)) / numberOfDigits
            
        } else {
            
            return Double(ceil(self * numberOfDigits)) / numberOfDigits
            
        }
        
    }
    
    // 四捨五入
    func rounding(toDecimal decimal: Int) -> Double {
        
        let numberOfDigits = pow(10.0, Double(decimal))
        
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
        
    }
    
}
