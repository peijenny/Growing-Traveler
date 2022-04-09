//
//  StudyGoalViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit

class StudyGoalViewController: UIViewController {
    
    @IBOutlet weak var addGoalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
