//
//  EditProductViewModel.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 02/04/2025.
//

import Foundation


class EditProductViewModel: ObservableObject {
    
    var onUpdateComplete: ((ProductEntity?) -> Void)?
    
    func updateProduct(id: Int, newName: String, newPrice: Double) {
        do {
            let updatedProduct = try CoreDataManager.shared.updateExistingProduct(id: id, title: newName, price: newPrice)
            onUpdateComplete?(updatedProduct)
        } catch {
            debugPrint("Failed to update product in Core Data: \(error)")
            onUpdateComplete?(nil)
        }
    }
}
