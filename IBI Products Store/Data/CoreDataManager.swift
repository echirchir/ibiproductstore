//
//  CoreDataManager.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 13/03/2025.
//

import Foundation
import CoreData
import os.log

protocol CoreDataManagerProtocol {
    func saveProducts(_ products: [Product]) throws
    func toggleFavorite(for productId: Int) throws -> Bool
    func deleteProduct(withId productId: Int) throws
    func getFavoritedProducts() throws -> [ProductEntity]
}

final class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IBIDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                self.logError(error)
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private func saveContext(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            self.logError(error)
            throw CoreDataError.saveFailed(error)
        }
    }
    
    func saveProducts(_ products: [Product]) throws {
        try backgroundContext.performAndWait {
            for product in products {
                let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", product.id)
                
                do {
                    let existingProducts = try backgroundContext.fetch(fetchRequest)
                    if let existingProduct = existingProducts.first {
                        update(existingProduct, with: product)
                    } else {
                        createProductEntity(from: product, in: backgroundContext)
                    }
                } catch {
                    self.logError(error)
                    throw CoreDataError.fetchFailed(error)
                }
            }
            try saveContext(backgroundContext)
        }
    }
    
    func toggleFavorite(for productId: Int) throws -> Bool {
        try backgroundContext.performAndWait {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", productId)
            
            do {
                guard let productEntity = try backgroundContext.fetch(fetchRequest).first else {
                    throw CoreDataError.entityNotFound
                }
                productEntity.isFavorited.toggle()
                try saveContext(backgroundContext)
                return productEntity.isFavorited
            } catch {
                self.logError(error)
                throw CoreDataError.fetchFailed(error)
            }
        }
    }
    
    func deleteProduct(withId productId: Int) throws {
        try backgroundContext.performAndWait {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", productId)
            
            do {
                guard let productEntity = try backgroundContext.fetch(fetchRequest).first else {
                    throw CoreDataError.entityNotFound
                }
                backgroundContext.delete(productEntity)
                try saveContext(backgroundContext)
            } catch {
                self.logError(error)
                throw CoreDataError.fetchFailed(error)
            }
        }
    }
    
    func getFavoritedProducts() throws -> [ProductEntity] {
        try viewContext.performAndWait {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isFavorited == %@", NSNumber(value: true))
            
            do {
                return try viewContext.fetch(fetchRequest)
            } catch {
                self.logError(error)
                throw CoreDataError.fetchFailed(error)
            }
        }
    }
    
    func getAllProducts() throws -> [LocalProduct] {
        try viewContext.performAndWait {
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            let productEntities = try viewContext.fetch(fetchRequest)
            return productEntities.map { LocalProduct(from: $0) }
        }
    }
    
    private func update(_ productEntity: ProductEntity, with product: Product) {
        productEntity.title = product.title
        productEntity.brand = product.brand
        productEntity.price = product.price
        productEntity.thumbnail = product.thumbnail
        productEntity.desc = product.description
    }
    
    private func createProductEntity(from product: Product, in context: NSManagedObjectContext) {
        let productEntity = ProductEntity(context: context)
        productEntity.id = Int64(product.id)
        productEntity.title = product.title
        productEntity.brand = product.brand
        productEntity.price = product.price
        productEntity.thumbnail = product.thumbnail
        productEntity.desc = product.description
        productEntity.isFavorited = false
    }
    
    private func logError(_ error: Error) {
        os_log("CoreData Error: %@", log: .default, type: .error, error.localizedDescription)
    }
}

enum CoreDataError: Error {
    case entityNotFound
    case saveFailed(Error)
    case fetchFailed(Error)
}
