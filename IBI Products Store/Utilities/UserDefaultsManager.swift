//
//  UserDefaultsManager.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation

fileprivate struct UserDefaultsKeys {
    static let isUserLoggedIn = "isUserLoggedIn"
    static let languageCode = "languageCode"
    static let appTheme = "appTheme"
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let manager = UserDefaults.standard
    
    private init() {}
    
    var isUserLoggedIn: Bool {
        set {
            manager.set(newValue, forKey: UserDefaultsKeys.isUserLoggedIn)
            manager.synchronize()
        }
        get {
            return manager.bool(forKey: UserDefaultsKeys.isUserLoggedIn)
        }
    }
    
    var languageCode: String {
        set {
            manager.set(newValue, forKey: UserDefaultsKeys.languageCode)
            manager.synchronize()
            NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
        }
        get {
            return manager.string(forKey: UserDefaultsKeys.languageCode) ?? LanguageCode.english.rawValue
        }
    }
    
    var appTheme: String {
        set {
            manager.set(newValue, forKey: UserDefaultsKeys.appTheme)
            manager.synchronize()
        }
        get {
            return manager.string(forKey: UserDefaultsKeys.appTheme) ?? AppTheme.light.rawValue
        }
    }
}
