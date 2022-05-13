//
//  AnalysisViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/20.
//

import UIKit
import PKHUD

class AnalysisViewController: UIViewController {
    
    @IBOutlet weak var analysisTableView: UITableView! {
        
        didSet {
            
            analysisTableView.delegate = self
            
            analysisTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var selectSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var analysisBackground: UIView!
    
    var analysisManager = AnalysisManager()
    
    var categoryManager = CategoryManager()
    
    var userManager = UserManager()
    
    var studyGoals: [StudyGoal] = [] {
        
        didSet {
            
            analysisTableView.reloadData()
            
        }
        
    }
    
    var calculates: [CalculateBar] = []
    
    var spendStudyItem = CalculateSpendStudyItem(itemsTime: [], itemsTitle: [])
    
    var finishedCalculates: [CalculatePie] = []
    
    var feedbacks: [Feedback] = [] {
        
        didSet {
            
            analysisTableView.reloadData()
            
        }
        
    }
    
    var feedback = Feedback(title: "", timeLimit: TimeLimit(lower: 0, upper: 0), comment: "")
    
    let day = 24 * 60 * 60
    
    var certificateText = ""
    
    var interesteText = ""
    
    var experienceValue = Int()
    
    var sevenDaysArray: [String] = []
    
    var calculateStudyTime: [Double] = [] {
        
        didSet {
            
            analysisTableView.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        analysisTableView.register(
            UINib(nibName: String(describing: AnalysisBarChatTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: AnalysisBarChatTableViewCell.self))
        
        analysisTableView.register(
            UINib(nibName: String(describing: AnalysisPieChartTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: AnalysisPieChartTableViewCell.self))
        
        analysisTableView.register(
            UINib(nibName: String(describing: AnalysisContentTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: AnalysisContentTableViewCell.self))
        
        selectSegmentedControl.addTarget(
            self, action: #selector(selectIndexChanged(_:)), for: .valueChanged)
        
        fetchFeedbackData()
        
        fetchStudyGoalData()
        
    }
    
    @objc func selectIndexChanged(_ send: UISegmentedControl) {
        
        analysisTableView.reloadData()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func fetchStudyGoalData() {
        
        analysisManager.fetchStudyData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let studyGoals):
                
                strongSelf.studyGoals = studyGoals
                
                strongSelf.handlePieChartData()
                
                strongSelf.handleBarChartData()
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func fetchFeedbackData() {
        
        analysisManager.fetchFeedbackData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let feetbacks):
                
                strongSelf.feedbacks = feetbacks
                
            case .failure(let error):
                
                print(error)
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }

    func handlePieChartData() {
        
        finishedCalculates.removeAll()
        
        spendStudyItem = CalculateSpendStudyItem(itemsTime: [], itemsTitle: [])

        let finishedStudyGoals = studyGoals.filter({ $0.studyItems.allSatisfy({ $0.isCompleted == true }) })
        
        for finishedIndex in 0..<finishedStudyGoals.count {
            
            var totalMinutes = 0
            
            let allStudyTime = finishedStudyGoals[finishedIndex].studyItems.map({ $0.studyTime })
            
            for index in 0..<allStudyTime.count {
                
                totalMinutes += allStudyTime[index]
                
            }
            
            finishedCalculates.append(CalculatePie(
                totalMinutes: Double(totalMinutes), categoryItem: finishedStudyGoals[finishedIndex].category))
            
        }
        
        analysisBackground.isHidden = (finishedCalculates.isEmpty) ? false : true
        
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
        
        var filterItemsTitle: [String] = []
        
        var filterItemTime: [Double] = []
        
        for (index, value) in spendStudyItem.itemsTitle.enumerated() {

            if filterItemsTitle.contains(value) {
                
                for filterIndex in 0..<filterItemsTitle.count {
                    
                    if filterItemsTitle[filterIndex] == value {
                        
                        filterItemTime[filterIndex] += spendStudyItem.itemsTime[index]
                        
                    }
                    
                }
                
                continue
                
            }
            
            filterItemsTitle.append(value)
            
            filterItemTime.append(spendStudyItem.itemsTime[index])

        }
        
        spendStudyItem.itemsTitle = filterItemsTitle
        
        spendStudyItem.itemsTime = filterItemTime
        
        handlePieChatFeedbackText()

    }
    
    func handlePieChatFeedbackText() {
        
        interesteText = ""
        
        certificateText = ""
        
        for categoryIndex in 0..<finishedCalculates.count {
            
            if interesteText.range(of: finishedCalculates[categoryIndex].categoryItem.intereste) == nil {
                
                interesteText += " ○ " + finishedCalculates[categoryIndex].categoryItem.intereste + "\n"
                
            }
            
            for index in 0..<finishedCalculates[categoryIndex].categoryItem.certificate.count {
                
                certificateText += " □ " + finishedCalculates[categoryIndex].categoryItem.certificate[index] + "\n"
                
            }
            
        }
        
    }
    
    func handleBarChartData() {
        
        calculates.removeAll()
        
        let yesterday = Date().addingTimeInterval(-Double((day))).addingTimeInterval(Double(day / 3))
        
        let sevenDaysAgo = Date().addingTimeInterval(-Double((day * 7))).addingTimeInterval(Double(day / 3))
        
        var finishItem = 0
        
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
                    
                    finishItem += 1
                    
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
                
            } else if endDate >= sevenDaysAgo && startDate <= yesterday {

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
        
        analysisBackground.isHidden = (calculates.isEmpty) ? false : true
        
        calculateSevenDayStudyTime()
        
        handleBarChatFeedbackText(finishItem: finishItem)

    }
    
    func handleBarChatFeedbackText(finishItem: Int) {
        
        var totalStudyTime = 0.0
        
        for index in 0..<calculateStudyTime.count {
            
            totalStudyTime += calculateStudyTime[index]
            
        }
        
        experienceValue = finishItem * 50
        
        for index in 0..<feedbacks.count {
            
            if Int(totalStudyTime) >= feedbacks[index].timeLimit.lower &&
                Int(totalStudyTime) <= feedbacks[index].timeLimit.upper {
                
                feedback = feedbacks[index]
                
            }
            
        }

    }
    
    func handleSevenDays(yesterday: Date) {
        
        sevenDaysArray = []
        
        let sevenDaysAgo = Date().addingTimeInterval(-Double((day * 7))).addingTimeInterval(Double(day / 3))
        
        for index in 0..<7 {
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "MM.dd"
            
            let displayDay = formatter.string(from: sevenDaysAgo.addingTimeInterval(Double(day * index)))
            
            sevenDaysArray.append(displayDay)
            
        }
        
    }
    
    func calculateSevenDayStudyTime() {
        
        calculateStudyTime = []
        
        for _ in 0..<sevenDaysArray.count {
            
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        guard let select = selectSegmentedControl.titleForSegment(
            at: selectSegmentedControl.selectedSegmentIndex) else { return UITableViewCell() }
         
        if indexPath.row == 0 {
            
            if select == "近七天學習時間" {
                
                cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: AnalysisBarChatTableViewCell.self), for: indexPath)

                guard let cell = cell as? AnalysisBarChatTableViewCell else { return cell }

                cell.updateChatsData(calculateStudyTime: calculateStudyTime, sevenDaysArray: sevenDaysArray)

            } else {
                
                cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: AnalysisPieChartTableViewCell.self), for: indexPath)

                guard let cell = cell as? AnalysisPieChartTableViewCell else { return cell }
                
                cell.updateChatsData(spendStudyItem: spendStudyItem)
                
            }
            
        } else {
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: AnalysisContentTableViewCell.self), for: indexPath)

            guard let cell = cell as? AnalysisContentTableViewCell else { return cell }
            
            if select == "近七天學習時間" {
                
                cell.showBarText(feedback: feedback, experienceValue: experienceValue)
                
            } else {
                
                cell.showPieText(certificateText: certificateText, interesteText: interesteText)
                
            }
            
        }
        
        cell.selectionStyle = .none

        return cell
        
    }
    
}
