//
//  ArticleMessageViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/16.
//

import UIKit

class ArticleMessageViewController: BaseViewController {

    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendImageView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
    }
    
}
