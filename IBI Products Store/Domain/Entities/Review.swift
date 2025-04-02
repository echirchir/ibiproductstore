//
//  Review.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation

struct Review: Codable {
    let rating: Int?
    let comment: String?
    let date: String?
    let reviewerName: String?
    let reviewerEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case rating = "rating"
        case comment = "comment"
        case date = "date"
        case reviewerName = "reviewerName"
        case reviewerEmail = "reviewerEmail"
    }
}
