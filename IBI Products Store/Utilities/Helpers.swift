//
//  Helpers.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation
import UIKit
import SDWebImage

// MARK: - Language Enum
enum LanguageCode: String {
    case english = "en"
    case hebrew = "he"
}

// MARK: - Theme Enum
enum AppTheme: String {
    case light = "light"
    case dark = "dark"
}

func logout(from viewController: UIViewController) {
    UserDefaultsManager.shared.isUserLoggedIn = false
    SDImageCache.shared.clear(with: .all)

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
        navigateToNextScreen(from: viewController, destination: loginVC)
    }
}

func navigateToNextScreen(from viewController: UIViewController, destination: UIViewController) {
    let transition = CATransition()
    transition.duration = 0.4
    transition.type = .moveIn
    transition.subtype = .fromRight
    transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    
    if let window = UIApplication.shared.connectedScenes
        .compactMap({ ($0 as? UIWindowScene)?.windows.first }).first {
        window.layer.add(transition, forKey: kCATransition)
        window.rootViewController = destination
    }
}

func changeAppLanguage() {
    
}
