//
//  ViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/7.
//

import UIKit

private enum Tab {
    
    case studyGoal
    
//    case forum
    
    case chat
    
    case analysis
    
    case profile
    
    case auth
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
        case .studyGoal: controller = UIStoryboard.studyGoal.instantiateInitialViewController() ?? UIViewController()
            
//        case .forum: controller = UIStoryboard.forum.instantiateInitialViewController() ??
//            UIViewController()
            
        case .chat: controller = UIStoryboard.chat.instantiateInitialViewController() ??
            UIViewController()
            
        case .analysis: controller = UIStoryboard.analysis.instantiateInitialViewController() ??
            UIViewController()
            
        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController() ??
            UIViewController()
            
        case .auth: controller = UIStoryboard.auth.instantiateInitialViewController() ??
            UIViewController()
            
        }
        
        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        
        return controller
        
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {
            
        case .studyGoal:

            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.targetOrigin),
                selectedImage: UIImage.asset(.targetSelect)
            )
            
//        case .forum:
//
//            return UITabBarItem(
//                title: nil,
//                image: UIImage.asset(.loudspeakerOrigin),
//                selectedImage: UIImage.asset(.loudspeakerSelect)
//            )
            
        case .chat:
            
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.chatBoxOrigin),
                selectedImage: UIImage.asset(.chatBoxSelect)
            )
            
        case .analysis:
            
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.statisticsOrigin),
                selectedImage: UIImage.asset(.statisticsSelect)
            )
            
        case .profile:
            
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.userOrigin),
                selectedImage: UIImage.asset(.userSelect)
            )
            
        case .auth:
            
            return UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
            
        }
         
    }
    
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
//    private let tabs: [Tab] = [.studyGoal, .forum, .chat, .analysis, .profile, .auth]
    
    private let tabs: [Tab] = [.studyGoal, .chat, .analysis, .profile, .auth]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.controller() })
        
        delegate = self
    }
    
}
