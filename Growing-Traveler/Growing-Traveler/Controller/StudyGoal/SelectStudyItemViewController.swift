//
//  SelectStudyItemViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/10.
//

import UIKit

class SelectStudyItemViewController: UIViewController {

    @IBOutlet weak var itemTextField: UITextField!
    
    @IBOutlet weak var studyTimeStackView: UIStackView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.view.removeFromSuperview()
        
    }
    
}
