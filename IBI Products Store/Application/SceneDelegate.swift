//
//  SceneDelegate.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let windowScene = scene as? UIWindowScene
        window = UIWindow(windowScene: windowScene!)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
        let isLoggedIn = UserDefaultsManager.shared.isUserLoggedIn
        
        let initialViewController: UIViewController
        
        if isLoggedIn {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        } else {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        }

        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        let savedTheme = UserDefaultsManager.shared.appTheme
        if let windowScene = scene as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = (savedTheme == AppTheme.light.rawValue) ? .light : .dark
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

