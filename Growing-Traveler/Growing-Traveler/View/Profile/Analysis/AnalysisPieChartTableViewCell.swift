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
        
        // Access data array, type - PieChartDataEntry
        var dataEntries: [ChartDataEntry] = []

        // Use for loop to put the data into array
        for index in 0..<spendStudyItem.itemsTime.count {

            // Set x, y
            let dataEntry = PieChartDataEntry(
                value: spendStudyItem.itemsTime[index], label: spendStudyItem.itemsTitle[index])

            // Put the data into array
            dataEntries.append(dataEntry)

        }

        // Set PieChartDataSet display data and label
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
        
        analysisPieChartView.animate(xAxisDuration: 1.0, easingOption: .easeOutQuad)

    }
    
}
