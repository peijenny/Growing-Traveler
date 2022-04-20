//
//  BlockadeFriendViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/19.
//

import UIKit

class BlockadeFriendViewController: UIViewController {
    
    var blockadeList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "封鎖列表"

        print("BlockadeList: \(blockadeList)")
        
    }

}
