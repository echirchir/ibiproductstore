//
//  String.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 13/03/2025.
//

import Foundation

extension String {
    
    var localized: String {
        get { return NSLocalizedString(self, comment: "") }
    }
    
    func decode<T: Decodable>(_ type : T.Type) -> T? {
        return try? JSONDecoder().decode(type, from: Data(self.utf8))
    }
}
