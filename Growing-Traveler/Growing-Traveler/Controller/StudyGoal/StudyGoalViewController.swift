//
//  StudyGoalViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit

class StudyGoalViewController: UIViewController {
    
    @IBOutlet weak var studyGoalTableView: UITableView! {
        
        didSet {
            
            studyGoalTableView.delegate = self
            
            studyGoalTableView.dataSource = self
            
        }
        
    }
    
    @IBOutlet weak var addGoalButton: UIButton!
    
    var studyGoalManager = StudyGoalManager()
    
    var studyGoals: [StudyGoal]? {
        
        didSet {
            
            studyGoalTableView.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studyGoalTableView.register(
            UINib(nibName: String(describing: StudyGoalHeaderView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: StudyGoalHeaderView.self)
        )
        
        studyGoalTableView.register(
            UINib(nibName: String(describing: StudyGoalFooterView.self), bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: StudyGoalFooterView.self)
        )
        
        studyGoalTableView.register(
            UINib(nibName: String(describing: StudyGoalTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: StudyGoalTableViewCell.self)
        )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        listenData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addGoalButton.imageView?.contentMode = .scaleAspectFill

        addGoalButton.layer.cornerRadius = addGoalButton.frame.width / 2
        
    }
    
    @IBAction func addStudyGoalButton(_ sender: UIButton) {
        
        let viewController = UIStoryboard(
            name: "StudyGoal",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: String(describing: PlanStudyGoalViewController.self)
        )
        
        guard let viewController = viewController as? PlanStudyGoalViewController else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func listenData() {
        
        studyGoalManager.listenData(completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                strongSelf.studyGoals = data
                
            case .failure(let error):
                
                print(error)
                
            }
            
        })
        
    }
    
}

extension StudyGoalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return studyGoals?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studyGoals?[section].studyItems.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: StudyGoalTableViewCell.self),
            for: indexPath
        )

        guard let cell = cell as? StudyGoalTableViewCell else { return cell }
        
        cell.studyItemLabel.text = studyGoals?[indexPath.section].studyItems[indexPath.row].itemTitle
        
        cell.checkButton.addTarget(
            self, action: #selector(checkItemButton), for: .touchUpInside
        )
        
        guard let isCompleted = studyGoals?[indexPath.section]
            .studyItems[indexPath.row].isCompleted else {
            
            return cell
            
        }
        
        if isCompleted {
            
            cell.checkButton.backgroundColor = UIColor.black
            
        } else {
            
            cell.checkButton.backgroundColor = UIColor.systemGray
            
        }
        
        return cell
        
    }
    
    @objc func checkItemButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: studyGoalTableView)

        if let indexPath = studyGoalTableView.indexPathForRow(at: point) {
            
            guard var studyGoals = studyGoals else { return }

            if sender.backgroundColor?.cgColor == UIColor.systemGray.cgColor {

                sender.backgroundColor = UIColor.black
                
                studyGoals[indexPath.section].studyItems[indexPath.row].isCompleted = true

            } else {

                sender.backgroundColor = UIColor.systemGray
                
                studyGoals[indexPath.section].studyItems[indexPath.row].isCompleted = false

            }
            
            studyGoalManager.updateData(studyGoal: studyGoals[indexPath.section])
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: StudyGoalHeaderView.self))

        guard let headerView = headerView as? StudyGoalHeaderView else { return headerView }
        
        headerView.studyGoalTitleLabel.text = studyGoals?[section].title
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        headerView.endDateLabel.text = formatter.string(from: studyGoals?[section].studyPeriod.endTime ?? Date())
        
        tableView.tableHeaderView = UIView.init(
            frame: CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        )
        
        tableView.contentInset = UIEdgeInsets.init(
            top: -headerView.frame.height, left: 0, bottom: 0, right: 0
        )
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: StudyGoalFooterView.self))

        guard let footerView = footerView as? StudyGoalFooterView else { return footerView }
        
        footerView.categoryLable.text = studyGoals?[section].category.title
        
        footerView.deleteButton.addTarget(
            self, action: #selector(deleteRowButton), for: .touchUpInside
        )
        
        tableView.tableFooterView = UIView.init(
            frame: CGRect.init(x: 0, y: 0, width: footerView.frame.width, height: footerView.frame.height)
        )
        tableView.contentInset = UIEdgeInsets.init(
            top: 0, left: 0, bottom: -footerView.frame.height, right: 0
        )
        
        return footerView
    }
    
    @objc func deleteRowButton(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: studyGoalTableView)

        if let indexPath = studyGoalTableView.indexPathForRow(at: point) {
            
            if let studyGoal = studyGoals?[indexPath.section] {
                
                studyGoalManager.deleteData(studyGoal: studyGoal)
                
            }
            
            studyGoals?.remove(at: indexPath.section)
            
        }

    }
    
}
