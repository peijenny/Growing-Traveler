//
//  AppDelegate.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/7.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var isForceLandscape: Bool = false
    
    var isForcePortrait: Bool = false
    
    var isForceAllDerictions: Bool = false // support all orientations
    
    // Set screen support orientation
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?)
    -> UIInterfaceOrientationMask {
        
        if isForceAllDerictions {
            
            return .all
            
        } else if isForceLandscape {
            
            return .landscape
            
        } else if isForcePortrait {
            
            return .portrait
            
        }
        
        return .portrait
        
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
//        do {
//
//           try  Auth.auth().signOut()
//
//        } catch {
//
//        }
             
        if let user = Auth.auth().currentUser {

            print("You're sign in as \(user.uid), email: \(user.email ?? "")")
            
            KeyToken().userID = "\(Auth.auth().currentUser?.uid ?? "")"

        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
        /*
         Called when the user discards a scene session.
         
         If any sessions were discarded while the application was not running,
         this will be called shortly after application:didFinishLaunchingWithOptions.
         
         Use this method to release any resources that were specific to the discarded scenes,
         as they will not return.
         
         */
        
    }

}
