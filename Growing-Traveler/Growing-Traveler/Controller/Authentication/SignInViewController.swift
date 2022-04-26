//
//  SignInViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signTableView: UITableView!
    
    var signType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backAuthPage(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
