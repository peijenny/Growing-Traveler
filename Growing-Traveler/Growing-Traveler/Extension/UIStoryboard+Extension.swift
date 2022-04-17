//
//  UIStoryboard+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/9.
//

import UIKit

private struct StoryboardCategory {
    
    static let main = "Main"
    
    static let studyGoal = "StudyGoal"
    
    static let forum = "Forum"
    
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return storyboard(name: StoryboardCategory.main) }
    
    static var studyGoal: UIStoryboard { return storyboard(name: StoryboardCategory.studyGoal) }
    
    static var forum: UIStoryboard { return storyboard(name: StoryboardCategory.forum) }
    
    private static func storyboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
