//
//  ProductResponse.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation

struct ProductResponse: Codable {
    let products: [Product]?
    let total: Int?
    let skip: Int?
    let limit: Int?
    
    enum CodingKeys: String, CodingKey {
        case products = "products"
        case total = "total"
        case skip = "skip"
        case limit = "limit"
    }
}
