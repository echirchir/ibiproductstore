//
//  ProductRepository.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation
import Combine
import Alamofire

protocol ProductsProtocol {
    func getProducts(skip: Int, limit: Int) -> AnyPublisher<DataResponse<ProductResponse, Network.ErrorResponse>, Never>
}

final class ProductsRepository: Network, ProductsProtocol {
    
    func getProducts(skip: Int, limit: Int) -> AnyPublisher<DataResponse<ProductResponse, Network.ErrorResponse>, Never> {
        var urlComponents = URLComponents(string: Urls.products.rawValue)
        
        // Add query parameters
        urlComponents?.queryItems = [
            URLQueryItem(name: "skip", value: "\(skip)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        let url = urlComponents?.url?.absoluteString ?? Urls.products.rawValue
        return get(url: url)
    }
}

extension ProductsRepository {
    fileprivate enum Urls: String {
        case products = "products"
    }
}

extension ProductsRepository {
    private static var sharedInstance: ProductsRepository?
    
    class var shared: ProductsRepository {
        guard let sharedInstance else {
            let instance = ProductsRepository()
            sharedInstance = instance
            return sharedInstance ?? .init()
        }
        return sharedInstance
    }
    
    class func destroy() {
        sharedInstance = nil
    }
}
