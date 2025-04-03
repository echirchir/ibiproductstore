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
    var shouldRefresh: Bool = false
    var productId: Int? = 0
    
    func fetchProducts(completion: @escaping((Bool) -> Void)) {
        guard !isFetching else { return }
        isFetching = true
        
        let coreDataProducts = fetchProductsFromCoreData()
        
        if coreDataProducts.count < totalProducts || totalProducts == 0 {
            ProductsRepository.shared.getProducts(skip: skip, limit: limit)
                .sink { [weak self] (dataResponse) in
                    guard let self = self else { return }
                    self.isFetching = false
                    
                    switch dataResponse.result {
                    case .success(let results):
                        let localProducts = results.products?.map { product in
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
                        
                        self.products.append(contentsOf: localProducts ?? [])
                        
                        self.totalProducts = results.total ?? 0
                        self.skip += results.products?.count ?? 0
                        
                        do {
                            try CoreDataManager.shared.saveProducts(results.products ?? [])
                        } catch {
                            debugPrint(error.localizedDescription)
                        }
                        
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
        do {
            let productEntities = try CoreDataManager.shared.getAllProducts()
            return productEntities
        } catch {
            debugPrint("Failed to fetch products from Core Data: \(error)")
            return []
        }
    }
    
    func refreshProduct(completion: @escaping((Bool) -> Void)) {
        do {
            guard let editedProductId = self.productId else {
                completion(false)
                return
            }
            
            guard let productEntity = try CoreDataManager.shared.getProductById(editedProductId) else {
                completion(false)
                return
            }
        
            if let index = products.firstIndex(where: { $0.id == productEntity.id }) {
                let updatedProduct = LocalProduct(
                    id: Int(productEntity.id),
                    title: productEntity.title ?? "",
                    brand: products[index].brand,
                    price: productEntity.price,
                    thumbnail: products[index].thumbnail,
                    description: products[index].description,
                    isFavorited: productEntity.isFavorited
                )
                
                DispatchQueue.main.async {
                    self.products[index] = updatedProduct
                }
            } else {
                print("Product not found in local array")
            }
            
            completion(true)
        } catch {
            completion(false)
            debugPrint("Failed to fetch products from Core Data: \(error)")
        }
    }
}
