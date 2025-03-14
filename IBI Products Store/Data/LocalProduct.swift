//
//  LocalProduct.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 13/03/2025.
//

import Foundation

struct LocalProduct {
    let id: Int
    let title: String
    let brand: String?
    let price: Double
    let thumbnail: String
    let description: String
    var isFavorited: Bool
}

extension LocalProduct {
    init(from entity: ProductEntity) {
        self.id = Int(entity.id)
        self.title = entity.title ?? ""
        self.brand = entity.brand
        self.price = entity.price
        self.thumbnail = entity.thumbnail ?? ""
        self.description = entity.desc ?? ""
        self.isFavorited = entity.isFavorited
    }
}
