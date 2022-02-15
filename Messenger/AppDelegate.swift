//
//  AppDelegate.swift
//  Messenger
//
//  Created by Олег Федоров on 10.02.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var firstRun: Bool?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        
        firstRunCheck()
        
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

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - First Run
    private func firstRunCheck() {
        print("DEBUG: first run check")
        
        firstRun = userDefaults.bool(forKey: KEY_FIRST_RUN)
        
        if !(firstRun ?? true) {
            print("DEBUG: this is first run")
            let status = Status.allStatuses
            
            userDefaults.set(status, forKey: KEY_STATUS)
            userDefaults.set(true, forKey: KEY_FIRST_RUN)
            
            userDefaults.synchronize()
        }
    }
}

