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
    
}

extension StudyGoalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: StudyGoalTableViewCell.self),
            for: indexPath
        )

        guard let cell = cell as? StudyGoalTableViewCell else { return cell }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: StudyGoalHeaderView.self))

        guard let headerView = headerView as? StudyGoalHeaderView else { return headerView }
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: StudyGoalFooterView.self))

        guard let footerView = footerView as? StudyGoalFooterView else { return footerView }
        
        return footerView
    }
    
}
