//
//  DetailsViewControllerDelegate.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 13/03/2025.
//

import Foundation

protocol DetailsViewControllerDelegate: AnyObject {
    func didDeleteProduct(withId productId: Int)
}
