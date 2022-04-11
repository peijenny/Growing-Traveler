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
    
    var topCGFloat = CGFloat()
    
    var bottomCGFloat = CGFloat()
    
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
        
        pushToPlanStudyGoalPage(studyGoal: nil)
        
    }
    
    func pushToPlanStudyGoalPage(studyGoal: StudyGoal?) {
        
        let viewController = UIStoryboard(
            name: "StudyGoal",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: String(describing: PlanStudyGoalViewController.self)
        )
        
        guard let viewController = viewController as? PlanStudyGoalViewController else { return }
        
        viewController.studyGoal = studyGoal
        
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
        
        topCGFloat = headerView.frame.height
        
        tableView.tableHeaderView = UIView.init(
            frame: CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        )

        setContentInset()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        headerView.addGestureRecognizer(tapGestureRecognizer)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: StudyGoalFooterView.self))

        guard let footerView = footerView as? StudyGoalFooterView else { return footerView }
        
        footerView.categoryLabel.text = studyGoals?[section].category.title
        
        footerView.hideRecordLabel.text = "\(studyGoals?[section].id ?? "")"
        
        footerView.deleteButton.addTarget(
            self, action: #selector(deleteRowButton), for: .touchUpInside
        )
        
        bottomCGFloat = footerView.frame.height
        
        tableView.tableFooterView = UIView.init(
            frame: CGRect.init(x: 0, y: 0, width: footerView.frame.width, height: footerView.frame.height)
        )
        
        setContentInset()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        footerView.addGestureRecognizer(tapGestureRecognizer)
        
        return footerView
    }
    
    func setContentInset() {
        
        studyGoalTableView.contentInset = UIEdgeInsets.init(
            top: -topCGFloat, left: 0, bottom: -bottomCGFloat, right: 0
        )
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {

        let headerView = sender.view as? StudyGoalHeaderView
        
        let footerView = sender.view as? StudyGoalFooterView
        
        for index in 0..<(studyGoals?.count ?? 0) {
            
            if sender.view == headerView &&
                headerView?.studyGoalTitleLabel.text == studyGoals?[index].title {
                
                pushToPlanStudyGoalPage(studyGoal: studyGoals?[index])
                
            }
            
            if sender.view == footerView &&
                footerView?.hideRecordLabel.text == studyGoals?[index].id {
                
                pushToPlanStudyGoalPage(studyGoal: studyGoals?[index])
                
            }
            
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let studyGoal = studyGoals?[indexPath.section] {
            
            pushToPlanStudyGoalPage(studyGoal: studyGoal)
            
        }
        
    }
    
}
