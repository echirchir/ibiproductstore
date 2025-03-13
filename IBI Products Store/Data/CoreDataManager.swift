//
//  CoreDataManager.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 13/03/2025.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IBIDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    func saveProducts(_ products: [Product]) {
        for product in products {
            
            print("The product saved is \(product.title)")
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", product.id)
            
            do {
                let existingProducts = try context.fetch(fetchRequest)
                
                if let existingProduct = existingProducts.first {
                    existingProduct.title = product.title
                    existingProduct.brand = product.brand
                    existingProduct.price = product.price
                    existingProduct.thumbnail = product.thumbnail
                    existingProduct.desc = product.description
                } else {
                    let productEntity = ProductEntity(context: context)
                    productEntity.id = Int64(product.id)
                    productEntity.title = product.title
                    productEntity.brand = product.brand
                    productEntity.price = product.price
                    productEntity.thumbnail = product.thumbnail
                    productEntity.desc = product.description
                    productEntity.isFavorited = false
                }
            } catch {
                print("Failed to fetch existing product: \(error)")
            }
        }
        
        saveContext()
    }
    
    func toggleFavorite(for productId: Int) -> Bool {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", productId)
        
        do {
            if let productEntity = try context.fetch(fetchRequest).first {
                productEntity.isFavorited.toggle()
                saveContext()
                return productEntity.isFavorited
            }
        } catch {
            print("Failed to toggle favorite: \(error)")
        }
        return false
    }
    
    func deleteProduct(withId productId: Int) {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", productId)
        
        do {
            if let productEntity = try context.fetch(fetchRequest).first {
                context.delete(productEntity)
                saveContext()
            }
        } catch {
            print("Failed to delete product: \(error)")
        }
    }
}
