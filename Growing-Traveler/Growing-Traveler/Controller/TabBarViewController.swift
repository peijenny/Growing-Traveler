//
//  ViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/7.
//

import UIKit

private enum Tab {
    
    case studyGoal
    
    case forum
    
    case chat
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
        case .studyGoal: controller = UIStoryboard.studyGoal.instantiateInitialViewController() ?? UIViewController()
            
        case .forum: controller = UIStoryboard.forum.instantiateInitialViewController() ??
            UIViewController()
            
        case .chat: controller = UIStoryboard.chat.instantiateInitialViewController() ??
            UIViewController()
            
        }
        
        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        
        return controller
        
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {
            
        case .studyGoal:

            return UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
            
        case .forum:
            
            return UITabBarItem(tabBarSystemItem: .featured, tag: 0)
            
        case .chat:
            
            return UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
            
        }
    }
    
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private let tabs: [Tab] = [.studyGoal, .forum, .chat]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.controller() })
        
        delegate = self
    }
    
}
