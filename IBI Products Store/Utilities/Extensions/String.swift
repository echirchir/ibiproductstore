//
//  String.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 13/03/2025.
//

import Foundation

extension String {
    var localized: String {
        let preferredLanguage = UserDefaultsManager.shared.languageCode
        let availableLanguages = Bundle.main.localizations
        
        if let path = Bundle.main.path(forResource: preferredLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            let translation = bundle.localizedString(forKey: self, value: nil, table: nil)
            if translation != self {
                return translation
            }
        }
        
        if let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }

        return self
    }
}
