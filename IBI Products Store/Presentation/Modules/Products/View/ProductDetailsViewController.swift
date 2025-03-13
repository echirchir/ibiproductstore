//
//  ProductDetailsViewController.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import UIKit
import SDWebImage

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var favoriteProductImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var product: LocalProduct?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productImage.sd_setImage(with: URL(string: product?.thumbnail ?? ""), placeholderImage: UIImage(named: "car.2"))
        productName.text = product?.title
        productDescription.text = product?.description
        productBrand.text = product?.brand
        productPrice.text = "₪\(product?.price ?? 0.0)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFavoriteOfProduct))
        favoriteProductImage.addGestureRecognizer(tapGesture)
        
        updateFavoriteButton(isFavorited: product?.isFavorited ?? false)
    }
    
    @objc func handleFavoriteOfProduct() {
        toggleFavorite()
    }
    
    @IBAction func onDeleteProductAction(_ sender: Any) {
        
    }
    
    @IBAction func onEditProductAction(_ sender: Any) {
        
    }
    
    func toggleFavorite() {
        guard let product = product else { return }
        
        // Toggle isFavorited in Core Data and get the new state
        let newFavoriteState = CoreDataManager.shared.toggleFavorite(for: product.id)
        
        // Update the local product property
        self.product?.isFavorited = newFavoriteState
        
        // Optionally, update the UI to reflect the new state
        updateFavoriteButton(isFavorited: newFavoriteState)
    }
    
    private func updateFavoriteButton(isFavorited: Bool) {
        favoriteProductImage.setImage(
            isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"),
            for: .normal
        )
    }
}
