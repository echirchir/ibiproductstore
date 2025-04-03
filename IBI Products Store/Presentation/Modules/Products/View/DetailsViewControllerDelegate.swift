//
//  DetailsViewControllerDelegate.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 13/03/2025.
//

import Foundation

@objc protocol DetailsViewControllerDelegate: AnyObject {
    func didDeleteProduct(withId productId: Int)
    @objc optional func productWasUpdated(withId productId: Int)
}
