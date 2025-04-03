//
//  ProductFilter.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 03/04/2025.
//

import Foundation

enum ProductFilter: String, CaseIterable {
    case none = "No Filter"
    case priceAscending = "Price ASC"
    case priceDescending = "Price DESC"
    case nameAscending = "Name ASC"
    case nameDescending = "Name DESC"
    
    var sortComparator: (LocalProduct, LocalProduct) -> Bool {
        switch self {
        case .none:
            return { _, _ in false }
        case .priceAscending:
            return { $0.price < $1.price }
        case .priceDescending:
            return { $0.price > $1.price }
        case .nameAscending:
            return { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .nameDescending:
            return { $0.title.localizedCompare($1.title) == .orderedDescending }
        }
    }
}
