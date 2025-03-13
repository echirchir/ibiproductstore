//
//  String.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 13/03/2025.
//

import Foundation

extension String {
    
    var localized: String {
        get {
            let currentLanguage = UserDefaultsManager.shared.languageCode
            let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj")
            let bundle = Bundle(path: path!)!
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
    }
    
    func decode<T: Decodable>(_ type : T.Type) -> T? {
        return try? JSONDecoder().decode(type, from: Data(self.utf8))
    }
    
    func localizedString(forKey key: String) -> String {
        let currentLanguage = UserDefaultsManager.shared.languageCode
        let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)!
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
