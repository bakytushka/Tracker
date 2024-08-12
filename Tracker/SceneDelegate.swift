//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Bakyt Temishov on 30.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if hasSeenOnboarding {
            window?.rootViewController = TabBarController()
        } else {
            let onboardingViewController = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            onboardingViewController.completionHandler = {
                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                UserDefaults.standard.synchronize()
                self.window?.rootViewController = TabBarController()
            }
            window?.rootViewController = onboardingViewController
        }
        
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

