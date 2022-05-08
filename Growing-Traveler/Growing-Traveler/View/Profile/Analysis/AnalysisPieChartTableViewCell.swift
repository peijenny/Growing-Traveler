//
//  AnalysisPieChartTableViewCell.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/21.
//

import UIKit
import Charts

class AnalysisPieChartTableViewCell: UITableViewCell {

    @IBOutlet weak var analysisPieChartView: PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateChatsData(spendStudyItem: CalculateSpendStudyItem) {
        
        analysisPieChartView.holeRadiusPercent = 0.382
        
        analysisPieChartView.transparentCircleRadiusPercent = 0.5
        
        // 存放資料的陣列，型態為 PieChartDataEntry
        var dataEntries: [ChartDataEntry] = []

        // 使用迴圈將資料加入存放資料的陣列中
        for index in 0..<spendStudyItem.itemsTime.count {

            // 設定 x, y 座標要顯示的東西有哪些
            let dataEntry = PieChartDataEntry(
                value: spendStudyItem.itemsTime[index],
                label: spendStudyItem.itemsTitle[index])

            // 將資料加入到陣列中
            dataEntries.append(dataEntry)

        }

        // 設定 PieChartDataSet 設定要顯示的資料是什麼，以及圖表下方的 Label
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "過去七天完成的學習項目")
        
        chartDataSet.colors = ChartColorTemplates.pastel()

        let chartData = PieChartData(dataSet: chartDataSet)

        let pFormatter = NumberFormatter()
        
        pFormatter.numberStyle = .percent
        
        pFormatter.maximumFractionDigits = 1
        
        pFormatter.multiplier = 1
        
        pFormatter.percentSymbol = " %"
        
        chartData.setValueFont(UIFont(name: "PingFang TC", size: 14)!)
        
        chartData.setValueTextColor(.white)

        analysisPieChartView.data = chartData
        
        analysisPieChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        analysisPieChartView.setNeedsDisplay()
        
        analysisPieChartView.animate(xAxisDuration: 2.0, easingOption: .easeOutElastic)
        
    }
    
}
