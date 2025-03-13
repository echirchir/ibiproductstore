//
//  Network.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation
import Combine
import Alamofire

class Network {
    
    private let timout: Double = 15
    
    func get<Model: Codable>(url: String, token: String? = nil, query: [String: Any]? = nil) -> AnyPublisher<DataResponse<Model, ErrorResponse>, Never> {
        debugPrint("http:url: \(base)\(url)")
        
        var headers: HTTPHeaders = [:]
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return AF.request("\(base)\(url)", method: .get, parameters: query, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .publishDecodable(type: Model.self)
            .map { response in
                debugPrint("http:res: \(response.debugDescription)")
                
                return response.mapError { error in
                    return ErrorResponse(code: error.responseCode ?? 0, message: error.errorDescription ?? "something_went_wrong")
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


extension Network {
    
    struct EmptyBody: EmptyResponse, Decodable {
        public static func emptyValue() -> Network.EmptyBody {
            return EmptyBody()
        }
    }
    
    struct ErrorResponse: Decodable, Error {
        let code: Int
        let message: String
    }
    
}

extension Network {
    
    fileprivate var schema: String {
        get { return "https" }
    }
    /// provide our host here for products api
    fileprivate var base_url_products: String {
        get { return "dummyjson.com/" }
    }
    
    /// provide the endpoint here / path
    fileprivate var base: String {
        get { return "\(schema)://\(base_url_products)" }
    }
}
