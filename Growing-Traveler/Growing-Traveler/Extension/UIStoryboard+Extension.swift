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
    
    static let chat = "Chat"
    
    static let note = "Note"
    
    static let profile = "Profile"
    
    static let auth = "Authentication"
    
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return storyboard(name: StoryboardCategory.main) }
    
    static var studyGoal: UIStoryboard { return storyboard(name: StoryboardCategory.studyGoal) }
    
    static var note: UIStoryboard { return storyboard(name: StoryboardCategory.note) }

    static var chat: UIStoryboard { return storyboard(name: StoryboardCategory.chat) }
    
    static var forum: UIStoryboard { return storyboard(name: StoryboardCategory.forum) }
    
    static var profile: UIStoryboard { return storyboard(name: StoryboardCategory.profile) }
    
    static var auth: UIStoryboard { return storyboard(name: StoryboardCategory.auth) }
    
    private static func storyboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
