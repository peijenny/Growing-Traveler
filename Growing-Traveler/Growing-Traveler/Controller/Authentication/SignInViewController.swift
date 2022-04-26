//
//  SignInViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/26.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signTableView: UITableView! {
        
        didSet {
            
            signTableView.delegate = self
            
            signTableView.dataSource = self
            
        }
        
    }
   
    var signType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signTableView.register(
            UINib(nibName: String(describing: SignInTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SignInTableViewCell.self)
        )
        
        signTableView.register(
            UINib(nibName: String(describing: SignUpTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: SignUpTableViewCell.self)
        )
        
    }

    @IBAction func backAuthPage(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension SignInViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if signType == SignType.signIn.title {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SignInTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SignInTableViewCell else { return cell }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SignUpTableViewCell.self), for: indexPath)
            
            guard let cell = cell as? SignUpTableViewCell else { return cell }
            
            return cell
            
        }
        
    }
    
}
