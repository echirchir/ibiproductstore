//
//  FavoritesViewModel.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation

class FavoritesViewModel {
    @Published var products: [LocalProduct] = []
    
    func loadFavoritedProducts() {
        do {
            let favoritedEntities = try CoreDataManager.shared.getFavoritedProducts()
            
            products = favoritedEntities.map { entity in
                LocalProduct(
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    brand: entity.brand ?? "Not Available",
                    price: entity.price,
                    thumbnail: entity.thumbnail ?? "",
                    description: entity.desc ?? "",
                    isFavorited: entity.isFavorited
                )
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
