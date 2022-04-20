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
    
    // 測試顯示資料
    var monthArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var temperatureArray: [Double] = [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]
    
    var axisFormatDelgate: AxisValueFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateChatsData()

    }
    
    func updateChatsData() {
        
        // 存放資料的陣列，型態為 BarChartDataEntry
        var dataEntries: [BarChartDataEntry] = []
        
        // 使用迴圈將資料加入存放資料的陣列中
        for index in 0..<monthArray.count {
            
            // 設定 x, y 座標要顯示的東西有哪些
            let dataEntry = BarChartDataEntry(x: Double(index), y: temperatureArray[index])
            
            // 將資料加入到陣列中
            dataEntries.append(dataEntry)
            
        }
        
        // 設定 BarChartDataSet 設定要顯示的資料是什麼，以及圖表下方的 Label
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Temperature per month")
        
        chartDataSet.colors = ChartColorTemplates.colorful()
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        analysisBarChatView.data = chartData
        
        analysisBarChatView.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthArray)
        
        analysisBarChatView.xAxis.granularity = 1
        
    }

}
