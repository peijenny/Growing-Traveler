//
//  FormViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit

class FormViewController: UIViewController {

    @IBOutlet weak var addArticleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addArticleButton.imageView?.contentMode = .scaleAspectFill

        addArticleButton.layer.cornerRadius = addArticleButton.frame.width / 2
        
    }
    
    @IBAction func addArticleButton(_ sender: UIButton) {
        
        let viewController = UIStoryboard(
            name: "Forum",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: String(describing: PublishForumArticleViewController.self)
        )
        
        guard let viewController = viewController as? PublishForumArticleViewController else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
