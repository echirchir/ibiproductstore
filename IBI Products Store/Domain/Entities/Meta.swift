//
//  Meta.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation

struct Meta: Codable {
    let createdAt: String
    let updatedAt: String
    let barcode: String
    let qrCode: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case barcode = "barcode"
        case qrCode = "qrCode"
    }
}
