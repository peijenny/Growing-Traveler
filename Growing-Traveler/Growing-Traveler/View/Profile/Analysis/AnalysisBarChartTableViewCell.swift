//
//  AnalysisChatTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/20.
//

import UIKit
import Charts

class AnalysisBarChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var analysisBarChatView: BarChartView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateChatsData(calculateStudyTime: [Double], sevenDaysArray: [String]) {
        
        // Access data array, type - BarChartDataEntry
        var dataEntries: [BarChartDataEntry] = []

        // Use for loop to put the data into array
        for index in 0..<calculateStudyTime.count {
            
            // Set x, y
            let dataEntry = BarChartDataEntry(x: Double(index), y: calculateStudyTime[index])
            
            // Put the data into array
            dataEntries.append(dataEntry)
            
        }
        
        // Set BarChartDataSet display data and label
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "過去七天的學習時數")

        chartDataSet.colors = ChartColorTemplates.pastel()
        
        analysisBarChatView.gridBackgroundColor = UIColor.red
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let pFormatter = NumberFormatter()
        
        pFormatter.numberStyle = .percent
        
        pFormatter.maximumFractionDigits = 1
        
        pFormatter.multiplier = 1
        
        pFormatter.percentSymbol = "小時"
        
        chartData.setValueFont(UIFont(name: "PingFang TC", size: 11)!)
        
        analysisBarChatView.data = chartData
        
        analysisBarChatView.data?.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        analysisBarChatView.xAxis.valueFormatter = IndexAxisValueFormatter(values: sevenDaysArray)
        
        analysisBarChatView.xAxis.granularity = 1
        
        analysisBarChatView.setNeedsDisplay()
        
        analysisBarChatView.animate(xAxisDuration: 1.0, easingOption: .easeOutQuad)
        
    }
    
}
