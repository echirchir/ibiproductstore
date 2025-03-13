//
//  ProductsViewModel.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation
import Combine
import Alamofire
import CoreData

class ProductsViewModel {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var products: [LocalProduct] = []
    @Published var totalProducts: Int = 0
    private var skip = 0
    private let limit = 30
    private var isFetching = false
    
    func fetchProducts(completion: @escaping((Bool) -> Void)) {
        guard !isFetching else { return }
        isFetching = true
        
        let coreDataProducts = fetchProductsFromCoreData()
        
        if coreDataProducts.count < totalProducts || totalProducts == 0{
            ProductsRepository.shared.getProducts(skip: skip, limit: limit)
                .sink { [weak self] (dataResponse) in
                    guard let self = self else { return }
                    self.isFetching = false
                    
                    switch dataResponse.result {
                    case .success(let results):
                        let localProducts = results.products.map { product in
                            LocalProduct(
                                id: product.id,
                                title: product.title,
                                brand: product.brand,
                                price: product.price,
                                thumbnail: product.thumbnail,
                                description: product.description,
                                isFavorited: false
                            )
                        }
                        
                        self.products.append(contentsOf: localProducts)
                        
                        self.totalProducts = results.total
                        self.skip += results.products.count
                        
                        CoreDataManager.shared.saveProducts(results.products)
                        
                        completion(true)
                    case .failure(_):
                        completion(false)
                    }
                }
                .store(in: &cancellables)
        } else {
            self.products = coreDataProducts
            completion(true)
            isFetching = false
        }
    }
    
    private func fetchProductsFromCoreData() -> [LocalProduct] {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        do {
            let productEntities = try CoreDataManager.shared.context.fetch(fetchRequest)
            return productEntities.map { LocalProduct(from: $0) }
        } catch {
            print("Failed to fetch products from Core Data: \(error)")
            return []
        }
    }
    
    deinit {
        cancellables.removeAll()
        ProductsRepository.destroy()
    }
}
