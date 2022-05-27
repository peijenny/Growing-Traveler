//
//  AnalysisViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/20.
//

import UIKit

class AnalysisViewController: UIViewController {
    
    // MARK: - IBOutlet / Components
    @IBOutlet weak var analysisTableView: UITableView! {
        
        didSet {
            
            analysisTableView.delegate = self
            
            analysisTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var selectSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var analysisBackground: UIView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var analysisBackgroundView: UIView!
    
    // MARK: - Property
    var handleAnalysisManager = HandleAnalysisManager()
    
    var analysisManager = AnalysisManager()
    
    var categoryManager = CategoryManager()
    
    var userManager = UserManager()
    
    var feedback = Feedback(title: "", timeLimit: TimeLimit(lower: 0, upper: 0), comment: "")
    
    var spendStudyItem = CalculateSpendStudyItem(itemsTime: [], itemsTitle: [])
    
    var calculateStudyTime: [Double] = []
    
    var sevenDaysArray: [String] = []
    
    var experienceValue = Int()
    
    var certificateText = ""
    
    var interesteText = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIStyle()
        
        setNavigationItem()
        
        registerTableViewCell()
        
        fetchStudyGoalData()
        
        handleAnalysisManager.delegate = self
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    // MARK: - Set UI
    func setNavigationItem() {
        
        selectSegmentedControl.addTarget(
            self, action: #selector(selectIndexChanged(_:)), for: .valueChanged)
        
    }
    
    func registerTableViewCell() {
        
        analysisTableView.register(
            UINib(nibName: String(describing: AnalysisBarChartTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: AnalysisBarChartTableViewCell.self))
        
        analysisTableView.register(
            UINib(nibName: String(describing: AnalysisPieChartTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: AnalysisPieChartTableViewCell.self))
        
        analysisTableView.register(
            UINib(nibName: String(describing: AnalysisContentTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: AnalysisContentTableViewCell.self))
        
    }
    
    func setUIStyle() {
        
        selectSegmentedControl.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.darkBlue.hexText)
        
        selectSegmentedControl.selectedSegmentTintColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
        headerView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        analysisBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightGary.hexText)
        
    }
    
    // MARK: - Method
    func fetchStudyGoalData() {
        
        analysisManager.fetchStudyData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let studyGoals):
                
                self.fetchFeedbackData(studyGoals: studyGoals)
                
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    func fetchFeedbackData(studyGoals: [StudyGoal]) {
        
        analysisManager.fetchFeedbackData { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let feedbacks):
                
                self.handleAnalysisManager.handlePieChartData(studyGoals: studyGoals)
                
                self.handleAnalysisManager.handleBarChartData(studyGoals: studyGoals, feedbacks: feedbacks)
            
            case .failure:
                
                HandleResult.readDataFailed.messageHUD
                
            }
            
        }
        
    }
    
    // MARK: - Target / IBAction
    @objc func selectIndexChanged(_ send: UISegmentedControl) {
        
        analysisTableView.reloadData()
        
    }

}

// MARK: - TableView delegate / dataSource
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
                    withIdentifier: String(describing: AnalysisBarChartTableViewCell.self), for: indexPath)

                guard let cell = cell as? AnalysisBarChartTableViewCell else { return cell }

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

// MARK: - Handle  analysis Delegate
extension AnalysisViewController: HandleAnalysisDelegate {
    
    func handleAnalysisBar(_ manager: HandleAnalysisManager, calculateStudyTime: [Double], sevenDaysArray: [String]) {
        
        self.calculateStudyTime = calculateStudyTime
        
        self.sevenDaysArray = sevenDaysArray
        
        analysisTableView.reloadData()
        
    }
    
    func handleAnalysisPie(_ manager: HandleAnalysisManager, spendStudyItem: CalculateSpendStudyItem) {
        
        self.spendStudyItem = spendStudyItem
        
        analysisTableView.reloadData()
        
    }
    
    func handleBarContent(_ manager: HandleAnalysisManager, feedback: Feedback, experienceValue: Int) {
        
        self.feedback = feedback
        
        self.experienceValue = experienceValue
        
        analysisTableView.reloadData()
        
    }
    
    func handlePieContent(_ manager: HandleAnalysisManager, certificateText: String, interesteText: String) {
        
        self.certificateText = certificateText
        
        self.interesteText = interesteText
        
        analysisTableView.reloadData()
        
    }
    
}
