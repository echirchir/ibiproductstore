//
//  ProductsViewModel.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation
import Combine
import Alamofire

class ProductsViewModel {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var products: [Product] = []
    @Published var totalProducts: Int = 0
    private var skip = 0
    private let limit = 30
    private var isFetching = false
    
    func fetchProducts(completeion: @escaping((Bool) -> Void)) {
        guard !isFetching else { return }
        isFetching = true
        
        ProductsRepository.shared.getProducts(skip: skip, limit: limit)
            .sink { [weak self] (dataResponse) in
                guard let self = self else { return }
                self.isFetching = false
                
                switch dataResponse.result {
                case .success(let results):
                    self.isFetching = false
                    self.products.append(contentsOf: results.products)
                    self.totalProducts = results.total
                    self.skip += results.products.count
                    completeion(true)
                case .failure(_):
                    completeion(false)
                }
            }.store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
        ProductsRepository.destroy()
    }
}
