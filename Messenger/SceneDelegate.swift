//
//  SceneDelegate.swift
//  Messenger
//
//  Created by Олег Федоров on 10.02.2022.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authListener: AuthStateDidChangeListenerHandle?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        autoLogin()
    }

    // MARK: - Autologin
    func autoLogin() {
    
        authListener = Auth.auth().addStateDidChangeListener { auth, user in
            
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            
            if user != nil && userDefaults.object(forKey: KEY_CURRENT_USER) != nil {
                
                DispatchQueue.main.async {
                    self.goToApp()
                }
            } 
        }
    }
    
    private func goToApp() {
        
        let mainView = UIStoryboard(
            name: "Main", bundle: nil
        ).instantiateViewController(withIdentifier: "MainApp") as! UITabBarController
        
        window?.rootViewController = mainView
    }
}

