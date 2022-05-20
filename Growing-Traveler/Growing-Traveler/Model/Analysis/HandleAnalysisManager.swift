//
//  HandleAnalysisManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/19.
//

import UIKit

protocol HandleAnalysisDelegate: AnyObject {
    
    func handleAnalysisBar(_ manager: HandleAnalysisManager, calculateStudyTime: [Double], sevenDaysArray: [String])
    
    func handleAnalysisPie(_ manager: HandleAnalysisManager, spendStudyItem: CalculateSpendStudyItem)
    
    func handleBarContent(_ manager: HandleAnalysisManager, feedback: Feedback, experienceValue: Int)
    
    func handlePieContent(_ manager: HandleAnalysisManager, certificateText: String, interesteText: String)
    
}

class HandleAnalysisManager {
    
    var spendStudyItem = CalculateSpendStudyItem(itemsTime: [], itemsTitle: [])
    
    var feedback = Feedback(title: "", timeLimit: TimeLimit(lower: 0, upper: 0), comment: "")
    
    var certificateText = ""
    
    var interesteText = ""
    
    var experienceValue = Int()
    
    var sevenDaysArray: [String] = []
    
    var calculateStudyTime: [Double] = []
    
    var finishedCalculates: [CalculatePie] = []
    
    var calculates: [CalculateBar] = []

    let day = 24 * 60 * 60
    
    weak var delegate: HandleAnalysisDelegate?
    
    func handlePieChartData(studyGoals: [StudyGoal]) {
        
        finishedCalculates = []
        
        spendStudyItem = CalculateSpendStudyItem(itemsTime: [], itemsTitle: [])
        
        countStudyTime(studyGoals: studyGoals)
        
        handleTimeCalculates(calculates: finishedCalculates)
        
        filterStudyGoalItems()
        
        handlePieChatFeedbackText()

    }
    
    private func countStudyTime(studyGoals: [StudyGoal]) {
        
        let filterStudyGoals = studyGoals.filter({ $0.studyItems.allSatisfy({ $0.isCompleted }) })
        
        for index in 0..<filterStudyGoals.count {
            
            var totalMinutes = 0
            
            let allStudyTime = filterStudyGoals[index].studyItems.map({ $0.studyTime })
            
            for index in 0..<allStudyTime.count {
                
                totalMinutes += allStudyTime[index]
                
            }
            
            finishedCalculates.append(CalculatePie(
                totalMinutes: Double(totalMinutes), categoryItem: filterStudyGoals[index].category))
            
        }
        
    }
    
    private func handleTimeCalculates(calculates: [CalculatePie]) {
        
        var allTime: Double = 0
        
        for index in 0..<calculates.count {
            
            allTime += calculates[index].totalMinutes
        }
        
        allTime /= 100
        
        for index in 0..<calculates.count {

            let itemTime = (calculates[index].totalMinutes / allTime)
            
            spendStudyItem.itemsTime.append(itemTime)
            
            spendStudyItem.itemsTitle.append(calculates[index].categoryItem.title)
            
        }
        
    }
    
    private func filterStudyGoalItems() {
        
        var filterItemsTitle: [String] = []
        
        var filterItemTime: [Double] = []
        
        for (index, value) in spendStudyItem.itemsTitle.enumerated() {

            if filterItemsTitle.contains(value) {
                
                let filterItems = filterItemsTitle.getArrayIndex(value)
                
                for filterIndex in filterItems {
                    
                    filterItemTime[filterIndex] += spendStudyItem.itemsTime[index]
                    
                }
                
                continue
                
            }
            
            filterItemsTitle.append(value)
            
            filterItemTime.append(spendStudyItem.itemsTime[index])

        }
        
        spendStudyItem.itemsTitle = filterItemsTitle
        
        spendStudyItem.itemsTime = filterItemTime
        
        delegate?.handleAnalysisPie(self, spendStudyItem: spendStudyItem)
        
    }
    
    private func handlePieChatFeedbackText() {
        
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
        
        delegate?.handlePieContent(self, certificateText: certificateText, interesteText: interesteText)
        
    }
    
    func handleBarChartData(studyGoals: [StudyGoal], feedbacks: [Feedback]) {
    
    calculates.removeAll()
    
    let yesterday = Date().addingTimeInterval(-Double((day))).addingTimeInterval(Double(day / 3))
    
    let sevenDaysAgo = Date().addingTimeInterval(-Double((day * 7))).addingTimeInterval(Double(day / 3))
    
    var finishItem = 0
    
    handleSevenDays(yesterday: yesterday)
    
    for goalIndex in 0..<studyGoals.count {
        
        var totalMinutes = 0
        
        let startDate = Date(
            timeIntervalSince1970: studyGoals[goalIndex].studyPeriod.startDate).addingTimeInterval(Double(day))
        
        let endDate = Date(
            timeIntervalSince1970: studyGoals[goalIndex].studyPeriod.endDate).addingTimeInterval(Double(day))
        
        let studyItems = studyGoals[goalIndex].studyItems
        
        for index in 0..<studyItems.count {
            
            totalMinutes += (studyItems[index].isCompleted) ? studyItems[index].studyTime : 0
            
            finishItem += (studyItems[index].isCompleted) ? 1 : 0
            
        }
        
        let periodDays = checkDiff(start: startDate, end: endDate)
        
        let averageTime = totalMinutes / periodDays
        
        let inCludedData = handleDates(countDate: CountDate(
            startDate: startDate, endDate: endDate, yesterday: yesterday,
            sevenDaysAgo: sevenDaysAgo, averageTime: averageTime))
        
        calculates.append(CalculateBar(
            startDate: startDate, endDate: endDate, periodDays: periodDays,
            totalMinutes: totalMinutes, averageMinutes: averageTime, includedDays: inCludedData.includedDays,
            included: inCludedData.includedArray))
        
    }
    
    calculateSevenDayStudyTime()
    
    handleBarChatFeedbackText(finishItem: finishItem, feedbacks: feedbacks)

}
    
    private func handleDates(countDate: CountDate) -> InCludedData {
        
        var includedDays = 0
        
        var includedArray: [Included] = []
        
        var studyTime = 0
        
        if countDate.startDate >= countDate.sevenDaysAgo && countDate.startDate <= countDate.yesterday {
            
            includedDays = checkDiff(start: countDate.startDate, end: countDate.yesterday)
            
            for index in 0..<sevenDaysArray.count {
                
                let studyDate = countDate.sevenDaysAgo.addingTimeInterval(Double(day * index))
                
                if countDate.startDate <= countDate.sevenDaysAgo.addingTimeInterval(Double(day * index)) {
                    
                    studyTime = countDate.averageTime
                    
                } else {
                    
                    studyTime = 0
                    
                }
                
                includedArray.append(Included(day: studyDate, time: studyTime))
                
            }

        } else if countDate.endDate >= countDate.sevenDaysAgo && countDate.endDate <= countDate.yesterday {
            
            includedDays = checkDiff(start: countDate.sevenDaysAgo, end: countDate.endDate)
            
            for index in 0..<sevenDaysArray.count {
                
                let studyDate = countDate.sevenDaysAgo.addingTimeInterval(Double(day * index))
                
                if countDate.endDate >= countDate.sevenDaysAgo.addingTimeInterval(Double(day * index)) {
                    
                    studyTime = countDate.averageTime
                    
                } else {
                    
                    studyTime = 0
                    
                }
                
                includedArray.append(Included(day: studyDate, time: studyTime))
                
            }
            
        } else if countDate.endDate >= countDate.sevenDaysAgo && countDate.startDate <= countDate.yesterday {

            includedDays = 7
            
            for index in 0..<includedDays {
                
                let studyDate = countDate.sevenDaysAgo.addingTimeInterval(Double(day * index))
                
                studyTime = countDate.averageTime
                
                includedArray.append(Included(day: studyDate, time: studyTime))
                
            }

        }
        
        return InCludedData(includedDays: includedDays, includedArray: includedArray)
        
    }
    
    private func handleBarChatFeedbackText(finishItem: Int, feedbacks: [Feedback]) {
        
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
        
        delegate?.handleBarContent(self, feedback: feedback, experienceValue: experienceValue)

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
        
    print("TEST \(sevenDaysArray)")
    
}
    
    private func calculateSevenDayStudyTime() {
        
        calculateStudyTime = []
        
        for _ in 0..<sevenDaysArray.count {
            
            calculateStudyTime.append(0.0)
            
        }
        
        for calculateIndex in 0..<calculates.count {
            
            for index in 0..<calculates[calculateIndex].included.count {

                calculateStudyTime[index] += Double(calculates[calculateIndex].included[index].time) / 60.0
                
            }
                
        }
        
        delegate?.handleAnalysisBar(self, calculateStudyTime: calculateStudyTime, sevenDaysArray: sevenDaysArray)

    }
    
    private func checkDiff(start: Date, end: Date) -> Int {
        
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
