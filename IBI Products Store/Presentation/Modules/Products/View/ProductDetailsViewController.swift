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
        CoreDataManager.shared.deleteProduct(withId: product?.id ?? 0)
        delegate?.didDeleteProduct(withId: product?.id ?? 0)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onEditProductAction(_ sender: Any) {
        
    }
    
    func toggleFavorite() {
        guard let product = product else { return }
        let newFavoriteState = CoreDataManager.shared.toggleFavorite(for: product.id)
        self.product?.isFavorited = newFavoriteState
        updateFavoriteButton(isFavorited: newFavoriteState)
    }
    
    private func updateFavoriteButton(isFavorited: Bool) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .default)
        let starImage = isFavorited ? UIImage(systemName: "star.fill", withConfiguration: symbolConfig) : UIImage(systemName: "star", withConfiguration: symbolConfig)
        
        favoriteProductImage.image = starImage
        favoriteProductImage.tintColor = isFavorited ? .systemYellow : .systemGray
    }
}
