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
    
    weak var delegate: DetailsViewControllerDelegate?
    
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
        do {
            try CoreDataManager.shared.deleteProduct(withId: product?.id ?? 0)
        } catch {
            print("Deletion failed here")
        }
        
        delegate?.didDeleteProduct(withId: product?.id ?? 0)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onEditProductAction(_ sender: Any) {
        performSegue(withIdentifier: "showEditProduct", sender: product)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditProduct" {
            if let editProductViewController = segue.destination as? EditProductViewController,
               let selectedProduct = sender as? LocalProduct {
                editProductViewController.product = selectedProduct
                editProductViewController.onUpdateComplete = { product in
                    if let product = product {
                        self.productName.text = product.title
                        self.productPrice.text = "₪\(product.price)"
                    }
                }
            }
        }
    }
    
    func toggleFavorite() {
        guard let product = product else { return }
        do {
            let newFavoriteState = try CoreDataManager.shared.toggleFavorite(for: product.id)
            self.product?.isFavorited = newFavoriteState
            updateFavoriteButton(isFavorited: newFavoriteState)
        } catch {
            debugPrint("Toggling failed")
        }
    }
    
    private func updateFavoriteButton(isFavorited: Bool) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .default)
        let starImage = isFavorited ? UIImage(systemName: "star.fill", withConfiguration: symbolConfig) : UIImage(systemName: "star", withConfiguration: symbolConfig)
        
        favoriteProductImage.image = starImage
        favoriteProductImage.tintColor = isFavorited ? .systemYellow : .systemGray
    }
}
