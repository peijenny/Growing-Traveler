//
//  ViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/7.
//

import UIKit

private enum Tab {
    
    case studyGoal
    
    case note
    
    case chat
    
    case forum
    
    case profile
    
//    case auth
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
        case .studyGoal: controller = UIStoryboard.studyGoal.instantiateInitialViewController() ?? UIViewController()
            
        case .note: controller = UIStoryboard.note.instantiateInitialViewController() ??
            UIViewController()
            
        case .chat: controller = UIStoryboard.chat.instantiateInitialViewController() ??
            UIViewController()
            
        case .forum: controller = UIStoryboard.forum.instantiateInitialViewController() ??
            UIViewController()
            
        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController() ??
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
                title: "目標",
                image: UIImage.asset(.archerySelect),
                selectedImage: UIImage.asset(.archerySelect)
            )
            
        case .note:
            
            return UITabBarItem(
                title: "筆記",
                image: UIImage.asset(.bookSelect),
                selectedImage: UIImage.asset(.bookSelect)
            )
        
        case .chat:
            
            return UITabBarItem(
                title: "聊天室",
                image: UIImage.asset(.speechBubbleSelect),
                selectedImage: UIImage.asset(.speechBubbleSelect)
            )
            
        case .forum:

            return UITabBarItem(
                title: "討論區",
                image: UIImage.asset(.speakerSelect),
                selectedImage: UIImage.asset(.speakerSelect)
            )
            
        case .profile:
            
            return UITabBarItem(
                title: "個人",
                image: UIImage.asset(.idCardSelect),
                selectedImage: UIImage.asset(.idCardSelect)
            )
            
        }
         
    }
    
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private let tabs: [Tab] = [.studyGoal, .note, .chat, .forum, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.controller() })
        
        tabBar.tintColor = UIColor.blue
        
        tabBar.barTintColor = UIColor.black
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 15)
        
        delegate = self
        
    }
    
    // MARK: - UITabBarControllerDelegate

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {

        if let viewControllers = tabBarController.viewControllers {
            
            if viewController != viewControllers[0] && viewController != viewControllers[1] {
                
                guard userID != "" else {

                    if let authViewController = UIStoryboard.auth.instantiateInitialViewController() {

                        authViewController.modalPresentationStyle = .popover

                        present(authViewController, animated: true, completion: nil)
                    }

                    return false
                }
                
            }
            
        }

        return true
        
    }
    
}
