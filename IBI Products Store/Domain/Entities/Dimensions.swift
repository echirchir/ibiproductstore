//
//  Dimensions.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation

struct Dimensions: Codable {
    let width: Double?
    let height: Double?
    let depth: Double?
    
    enum CodingKeys: String, CodingKey {
        case width = "width"
        case height = "height"
        case depth = "depth"
    }
}
