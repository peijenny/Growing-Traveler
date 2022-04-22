//
//  AnalysisChatTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/20.
//

import UIKit
import Charts

class AnalysisBarChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var analysisBarChatView: BarChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateChatsData(calculateStudyTime: [Double], sevenDaysArray: [String]) {
        
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
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "過去七天的學習時數")
        
        chartDataSet.colors = ChartColorTemplates.joyful()
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        analysisBarChatView.data = chartData
        
        analysisBarChatView.xAxis.valueFormatter = IndexAxisValueFormatter(values: sevenDaysArray)
        
        analysisBarChatView.xAxis.granularity = 1
        
        analysisBarChatView.setNeedsDisplay()
        
        analysisBarChatView.animate(xAxisDuration: 2.0, easingOption: .easeOutBack)
        
    }
    
}
